module AuthMaster
  class SessionsController < ApplicationController
    TIMING_ATTACK_INTERVAL = 1

    before_action :check_target_configuration

    before_action :check_token_presence, only: :link
    before_action :check_pre_session_id, only: :link

    around_action :prevent_timing_attack, only: :create

    # NOTE: Show input email form
    def new
    end

    def create
      uuid = Random.uuid
      session[session_key] = uuid

      AuthMaster::SendLinkOperation.call!(params[:email], target_scoped_class:, uuid:)
      redirect_to auth_master_sent_url(target: target_param)
    end

    def sent
    end

    def link
    end

    def activate
      uuid = session[session_key]
      auth_master_session = AuthMaster::CheckLinkOperation.call!(params[:token], uuid:, target_param_name:)
      (redirect_to(auth_master_denied_path(target: target_param_name)) and return) if auth_master_session.blank?

      session.delete(session_key)
      session[target_session_key] = auth_master_session.id

      # TODO: Use config for
      #   a) session key;
      #   b) default redirect path
      saved_path = session.delete("redirect_to")
      redirect_to(saved_path || "/")
    end

    def destroy
      auth_master_session_id = session.delete(target_session_key)
      AuthMaster::LogoutOperation.call!(auth_master_session_id)

      # TODO: Use config for redirect_path
      redirect_to("/")
    end

    private

    def session_key
      [ "auth_master", params[:target].to_s, "id" ].join("_")
    end

    def prevent_timing_attack
      start_time = Time.current
      yield

      @timing_attack_interval = timing_attack_interval
      if @timing_attack_interval.positive?
        duration = Time.current - start_time
        sleep(@timing_attack_interval - duration) if duration < @timing_attack_interval
      end
    end

    def timing_attack_interval
      AuthMaster.timing_attack_interval.presence || TIMING_ATTACK_INTERVAL
    end

    def check_token_presence
      raise ActionController::RoutingError.new("Not Found Token") if params[:token].blank?
    end

    def check_pre_session_id
      raise ActionController::RoutingError.new("Not Found Session") if session[session_key].blank?
    end

    def target_session_key
      [ "current", target_param_name, "id" ].join("_")
    end
  end
end
