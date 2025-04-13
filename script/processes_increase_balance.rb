user = User.find_by!(email: "panagiotis@matsinopoulos.gr")

user.user_balance.update(balance: 0.0)
JobLog.destroy_all

puts "Initial user_balance: #{user.user_balance.balance}"

5.times do |i|
  CalculateUserBalanceJob.perform_later(user.id)
end

sleep(60) # just wait for the background jobs to finish. This is long enough
# for all the 5 Sidekiq jobs to finish

user.reload

puts "user_balance: #{user.user_balance.balance} (expected is ?), updated by job_id: #{user.user_balance.job_id}"

puts "Printing all job logs:"

JobLog.order(:id).each do |job_log|
  puts "job_id: #{job_log.job_id}, balance: #{job_log.balance}"
end
