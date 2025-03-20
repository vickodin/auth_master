class Manager < ApplicationRecord
  normalizes :email, with: -> { it.strip.downcase }

  belongs_to :company

  scope :active, -> { where.not(email: nil) }
end
