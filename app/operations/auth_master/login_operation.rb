module AuthMaster
  class LoginOperation < AuthMaster::AbstractOperation
    def self.call!(target, uuid:)
      auth_master_session = AuthMaster::SessionService.create!(target, uuid:, force: true)
      AuthMaster::SessionService.activate!(auth_master_session)

      auth_master_session
    end
  end
end
