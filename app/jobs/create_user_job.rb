# frozen_string_literal: true

ADVISORY_LOCK_NAMESPACES = {
  create_user_job: 1
}

class CreateUserJob < ApplicationJob
  queue_as :default

  def perform(user_email)
    ActiveRecord::Base.transaction do
      # LOCKING >
      lock_namespace = ADVISORY_LOCK_NAMESPACES[:create_user_job]

      lock_key = user_email

      lock_comment = "CreateUserJob: #{provider_job_id} - #{user_email}"

      lock_query = <<~SQL.squish
        SELECT pg_advisory_xact_lock(:lock_namespace, hashtext(:key)) /* #{lock_comment} */
      SQL

      lock_query_args = {
        lock_namespace: lock_namespace,
        key: lock_key
      }

      sql = ActiveRecord::Base.sanitize_sql_array([ lock_query, lock_query_args ])

      ActiveRecord::Base.connection.execute(sql)
      # < LOCKING

      puts "************** #{provider_job_id} About to create user: #{user_email}"

      found = User.find_by(email: user_email)

      return if found

      sleep rand(5..10) # simulate some complex business logic to build the User object properly

      User.create!(email: user_email)

      puts "................ #{provider_job_id} FINISHED #{provider_job_id}"
    end
  end
end
