# frozen_string_literal: true

class User < ApplicationRecord
  has_one :user_balance, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  after_create :create_user_balance

  private

  def create_user_balance
    create_user_balance!(balance: 0.0)
  end
end
