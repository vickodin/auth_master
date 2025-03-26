require "token_guard"

module AuthMaster
  class SessionService
    LOGIN_TIMEOUT_INTERVAL  = 5.minutes
    LOGIN_ATTEMPTS_COUNT    = 3

    class << self
      def create!(target)
        return if !allow_creation?(target)

        AuthMaster::Session.create!(target:)
      end

      def send_link!(auth_master_session)
        target = auth_master_session.target

        token = TokenGuard.encrypt(auth_master_session.id, purpose: :email, secret: AuthMaster.targets[target_name(target)][:secret])
        target_mailer(target).with(email: target.email, token:).send(target_mailer_login_link_method(target)).deliver_later
      end

      private

      def count(target, time:)
        AuthMaster::Session.where(target:).where("created_at > ?", DateTime.current - time).count
      end

      def allow_creation?(target)
        count(target, time: login_timeout_interval(target)) < login_attempts_count(target)
      end

      def login_timeout_interval(target)
        AuthMaster.targets[target_name(target)][:login_timeout_interval] || LOGIN_TIMEOUT_INTERVAL
      end

      def login_attempts_count(target)
        AuthMaster.targets[target_name(target)][:login_attempts_count] || LOGIN_ATTEMPTS_COUNT
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
