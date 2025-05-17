require "token_guard"

module AuthMaster
  class TokenService
    extend AuthMaster::Config

    class << self
      def create!(auth_master_session, purpose:)
        purpose ||= token_purpose_config(auth_master_session.target)
        secret  = secret_config(auth_master_session.target)

        TokenGuard.encrypt(auth_master_session.id, purpose:, secret:)
      end
    end
  end
end
