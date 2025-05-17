module AuthMaster
  class PrepareTokenOperation < AuthMaster::AbstractOperation
    def self.call!(target, uuid:, purpose: nil)
      auth_master_session = AuthMaster::SessionService.create!(target, uuid:)
      return if auth_master_session.blank?

      AuthMaster::TokenService.create!(auth_master_session, purpose:)
      # purpose = token_purpose_config(target)
      # secret  = secret_config(target)

      # TokenGuard.encrypt(auth_master_session.id, purpose:, secret:)

      # mailer = target_mailer_config(target)
      # mailer_action = target_mailer_login_link_method(target)

      # url = AuthMaster::Engine.routes.url_helpers.auth_master_link_url(
      #   target: target_name(target),
      #   token: token,
      #   host: Rails.application.config.action_mailer.default_url_options[:host]
      # )

      # mailer.with(email: target.email, url:).public_send(mailer_action).deliver_later

      # auth_master_session
    end
  end
end
