# frozen_string_literal: true

class LongRunningBatchJob < ApplicationJob
  queue_as :default

  include EnqueueableJob

  def perform(batch_id)
    batch = Batch.find(batch_id)

    process_enqueued_job(queueable: batch) do
      # do the long running batch job
    end
  end
end
