require "token_guard"

module AuthMaster
  class SessionService

    DEFAULT_LOGIN_TIMEOUT_INTERVAL  = 5.minutes
    DEFAULT_LOGIN_ATTEMPTS_COUNT    = 3
    DEFAULT_TOKEN_PURPOSE           = :auth_master_email

    class << self
      def create!(target, uuid:)
        return if !allow_creation?(target)

        AuthMaster::Session.create!(target:, id: uuid)
      end

      def inactive_find(id)
        AuthMaster::Session.inactive.find_by(id:)
      end

      def activate!(auth_master_session)
        auth_master_session.active!
        # TODO: Save IP Address, User Agent, etc
      end

      def check_token(token)
        # auth_master_session_id = TokenGuard.decrypt(token, purpose: token_purpose(target), secret:)
      end

      private

      def count(target, time:)
        AuthMaster::Session.where(target:).where("created_at > ?", DateTime.current - time).count
      end

      def allow_creation?(target)
        count(target, time: login_timeout_interval(target)) < login_attempts_count(target)
      end

      def login_timeout_interval(target)
        AuthMaster.targets[target_name(target)][:login_timeout_interval] || DEFAULT_LOGIN_TIMEOUT_INTERVAL
      end

      def login_attempts_count(target)
        AuthMaster.targets[target_name(target)][:login_attempts_count] || DEFAULT_LOGIN_ATTEMPTS_COUNT
      end

      def token_purpose(target)
        # binding.irb
        AuthMaster.targets[target_name(target)][:token_purpose] || DEFAULT_TOKEN_PURPOSE
      end

      def target_name(target)
        target.class.to_s.downcase.to_sym
      end

      def target_mailer(target)
        config_for(target, :mailer_class).to_s.classify.constantize
      end

      def target_mailer_login_link_method(target)
        config_for(target, :mailer_login_link_method)
      end

      def config_for(target, name)
        AuthMaster.targets[target_name(target)][name.to_sym]
      end
    end
  end
end
