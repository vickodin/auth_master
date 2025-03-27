module AuthMaster
  class SessionsController < ApplicationController
    TIMING_ATTACK_INTERVAL = 1

    before_action :check_target_configuration
    
    before_action :check_token_presence,      only: :link
    before_action :check_session_time_stamp,  only: :link
    
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
      
      redirect_back(root_path)
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
      raise ActionController::RoutingError.new("Not Found") if params[:token].blank?
    end

    def check_session_time_stamp
      raise ActionController::RoutingError.new("Not Found") if session[session_key].blank?
    end
  end
end
