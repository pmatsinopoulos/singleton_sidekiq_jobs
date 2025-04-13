# frozen_string_literal: true

module EnqueueableJob
  extend ActiveSupport::Concern

  included do
    def process_enqueued_job(queueable:)
      enqueued_job = nil

      enqueued_job = EnqueuedJob.find_by(
        provider_job_id: [ provider_job_id, job_id ] # it seems that in +test+ env +provider_job_id+ is not present
      )

      if enqueued_job.present?
        yield

        enqueued_job.destroy! rescue nil
      end
    end
  end
end
