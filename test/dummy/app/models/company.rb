class Company < ApplicationRecord
  has_many :managers
  has_many :active_managers, -> { active }, class_name: Manager.name
end
