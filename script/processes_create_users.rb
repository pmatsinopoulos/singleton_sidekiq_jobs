user_email = "panagiotis@matsinopoulos.gr"

User.where(email: user_email).destroy_all

5.times do |i|
  CreateUserJob.perform_later(user_email)
end

sleep(60) # just wait for the background jobs to finish. This is long enough

puts "Number of users with given email: #{User.where(email: user_email).count}"
