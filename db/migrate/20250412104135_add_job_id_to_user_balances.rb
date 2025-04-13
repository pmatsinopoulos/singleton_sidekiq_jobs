class AddJobIdToUserBalances < ActiveRecord::Migration[8.0]
  def change
    add_column :user_balances, :job_id, :string
  end
end
