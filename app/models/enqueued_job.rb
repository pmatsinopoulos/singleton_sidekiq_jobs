# frozen_string_literal: true

class EnqueuedJob < ApplicationRecord
  belongs_to :queueable, polymorphic: true
end
