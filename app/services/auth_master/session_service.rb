require "token_guard"

module AuthMaster
  class SessionService
    extend AuthMaster::Config

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

      private

      def count(target, time:)
        AuthMaster::Session.where(target:).where("created_at > ?", DateTime.current - time).count
      end

      def allow_creation?(target)
        count(target, time: login_timeout_interval_config(target)) < login_attempts_count_config(target)
      end
    end
  end
end
