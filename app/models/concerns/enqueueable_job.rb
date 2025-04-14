# frozen_string_literal: true

module EnqueueableJob
  extend ActiveSupport::Concern

  included do
    def process_enqueued_job(queueable:)
      enqueued_job = nil

      ActiveRecord::Base.transaction do
        AdvisoryLock.lock(
          lock_namespace: queueable.queueable_lock_namespace,
          lock_key: queueable.queueable_lock_key(job_class_name: self.class.name),
          lock_comment: queueable.queueable_lock_comment(job_class_name: self.class.name)
        )

        enqueued_job = EnqueuedJob.where(
          provider_job_id: [ provider_job_id, job_id ] # it seems that in +test+ env +provider_job_id+ is not present
        ).first
      end

      if enqueued_job.present?
        yield instrumentation_payload

        Rails.logger.debug("--------------->******************* About to delete EnqueuedJob for provider_job_id: #{provider_job_id}, job_id: #{job_id}")

        begin
          enqueued_job.destroy!
        rescue
          nil
        end
      end
    end
  end
end
