module AuthMaster
  class Session < ApplicationRecord
    belongs_to :target, polymorphic: true

    enum :status, [ :inactive, :active, :logout ], default: :inactive
  end
end
