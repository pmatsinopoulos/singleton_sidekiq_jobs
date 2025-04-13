# frozen_string_literal: true

class CreateJobLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :job_logs do |t|
      t.string :job_id, null: false
      t.bigint :balance, null: false, default: 0

      t.timestamps
    end
  end
end
