module AuthMaster
  class SendLinkOperation < AuthMaster::AbstractOperation
    def self.call!(email, target_scoped_class:, uuid:)
      target = target_scoped_class.find_by(email:)
      return if target.blank?

      auth_master_session = AuthMaster::SessionService.create!(target, uuid:)
      return if auth_master_session.blank?

      purpose = token_purpose_config(target)
      secret  = secret_config(target)
      token = TokenGuard.encrypt(auth_master_session.id, purpose:, secret:)

      mailer = target_mailer_config(target)
      mailer_action = target_mailer_login_link_method(target)
      
      mailer.with(email: target.email, token:).public_send(mailer_action).deliver_later
      
      # auth_master_session
    end
  end
end
