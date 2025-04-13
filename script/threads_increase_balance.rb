user = User.find_by!(email: "panagiotis@matsinopoulos.gr")

puts "Initial user_balance: #{user.user_balance.balance}"

threads = []
5.times do
  threads << Thread.new do
    CalculateUserBalanceJob.perform_now(user.id)
  end
end

threads.each(&:join)

user.reload

puts "user_balance: #{user.user_balance.balance}"
