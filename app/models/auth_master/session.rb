module AuthMaster
  class Session < ApplicationRecord
    belongs_to :target, polymorphic: true

    enum :status, [ :inactive, :active ], default: :inactive
  end
end
