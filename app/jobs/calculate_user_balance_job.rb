# frozen_string_literal: true

class CalculateUserBalanceJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    User.transaction do
      user = User.lock.find(user_id)
      puts "************** #{provider_job_id} Calculating balance for user: #{user.email}"

      user_balance = user.user_balance

      sleep rand(5..10)

      new_balance = rand(5..50)
      user_balance.update!(balance: new_balance, job_id: provider_job_id)
      JobLog.create!(job_id: provider_job_id, balance: new_balance)
    end
    puts "................ #{provider_job_id} FINISHED #{provider_job_id}"
  end
end
