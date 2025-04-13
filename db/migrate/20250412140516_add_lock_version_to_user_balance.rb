class AddLockVersionToUserBalance < ActiveRecord::Migration[8.0]
  def change
    add_column :user_balances, :lock_version, :integer, default: 0, null: false
  end
end
