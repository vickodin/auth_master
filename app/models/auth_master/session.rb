module AuthMaster
  class Session < ApplicationRecord
    belongs_to :target, polymorphic: true
  end
end
