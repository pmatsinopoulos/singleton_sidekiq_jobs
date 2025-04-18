# frozen_string_literal: true

class CreateUserBalances < ActiveRecord::Migration[8.0]
  def change
    create_table :user_balances do |t|
      t.bigint :user_id, null: false
      t.bigint :balance, null: false, default: 0

      t.timestamps
    end

    add_index :user_balances, %i[user_id], unique: true
    add_foreign_key :user_balances, :users
  end
end
