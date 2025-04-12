# frozen_string_literal: true

class UserBalance < ApplicationRecord
  belongs_to :user, inverse_of: :user_balance
  validates :user_id, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :lock_version, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
