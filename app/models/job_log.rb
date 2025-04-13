# frozen_string_literal: true

class JobLog < ApplicationRecord
  validates :job_id, presence: true, uniqueness: { case_sensitive: false }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
