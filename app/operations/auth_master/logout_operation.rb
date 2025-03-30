module AuthMaster
  class LogoutOperation < AuthMaster::AbstractOperation
    def self.call!(auth_master_session_id)
      auth_master_session = AuthMaster::Session.active.find_by(id: auth_master_session_id)
      return if auth_master_session.blank?

      AuthMaster::SessionService.logout!(auth_master_session)
    end
  end
end
