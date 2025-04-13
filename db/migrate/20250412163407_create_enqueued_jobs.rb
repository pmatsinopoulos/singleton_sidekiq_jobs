class CreateEnqueuedJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :enqueued_jobs do |t|
      t.string :queueable_type, null: false
      t.bigint :queueable_id, null: false
      t.string :provider_job_id, null: false
      t.string :job_class_name, null: false

      t.timestamps
    end

    add_index :enqueued_jobs, %i[job_class_name queueable_type queueable_id], unique: true
    add_index :enqueued_jobs, %i[provider_job_id], unique: true
  end
end
