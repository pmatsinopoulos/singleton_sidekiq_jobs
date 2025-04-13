# frozen_string_literal: true

module Queueable
  extend ActiveSupport::Concern

  included do
    def enqueue(job_class_name:, schedule_options: {})
      result = false

      ActiveRecord::Base.transaction do
        AdvisoryLock.lock(
          lock_namespace: queueable_lock_namespace,
          lock_key: queueable_lock_key(job_class_name:),
          lock_comment: queueable_lock_comment(job_class_name:)
        )

        if enqueue?(job_class_name:)
          job_class = job_class_name.constantize
          job_class = job_class.set(schedule_options) unless schedule_options.blank?
          job = job_class.perform_later(id)

          EnqueuedJob.create!(
            queueable: self,
            job_class_name:,
            provider_job_id: job.provider_job_id || job.job_id, # it seems that in +test+ env +provider_job_id+ might not be present
            job_id: (job.job_id.nil? || job.job_id == 0) ? "missing-#{SecureRandom.hex}" : job.job_id,
            enqueuing_process_id: Process.pid,
            enqueuing_thread_id: Thread.current.object_id
          )

          result = true
        end
      end

      result
    end

    def enqueue?(job_class_name:)
      !enqueued?(job_class_name:)
    end

    def enqueued?(job_class_name:)
      EnqueuedJob.where(job_class_name:, queueable: self).any?
    end

    def enqueued_at(job_class_name:)
      EnqueuedJob.where(job_class_name:, queueable: self).order(created_at: :desc).first&.created_at
    end

    def queueable_lock_namespace
      ADVISORY_LOCK_NAMESPACES.fetch(:queueable)
    end

    def queueable_lock_key(job_class_name:)
      "#{self.class.name}-#{id}-#{job_class_name}"
    end

    def queueable_lock_comment(job_class_name:)
      "queueable: #{queueable_lock_key(job_class_name:)}"
    end
  end
end
