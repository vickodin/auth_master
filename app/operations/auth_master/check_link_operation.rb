module AuthMaster
  class CheckLinkOperation < AuthMaster::AbstractOperation
    def self.call!(encrypted_token, uuid:, target_param_name:)
      purpose = token_purpose_config(target_param_name)
      secret  = secret_config(target_param_name)

      auth_master_session_id = TokenGuard.decrypt(encrypted_token, purpose:, secret:)
      return if auth_master_session_id.blank?
      
      # NOTE: Auth from the same device
      return if auth_master_session_id != uuid

      auth_master_session = AuthMaster::SessionService.inactive_find(auth_master_session_id)
      return if auth_master_session.blank?

      AuthMaster::SessionService.activate!(auth_master_session)

      auth_master_session
    end
  end
end
