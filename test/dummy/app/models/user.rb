class User < ApplicationRecord
  normalizes :email, with: -> { it.strip.downcase }

  scope :active, -> { where.not(email: nil) }
end

# NOTE: Pseudo Admin class
Admin = User
