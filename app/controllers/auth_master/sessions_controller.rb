module AuthMaster
  class SessionsController < ApplicationController
    TIMING_ATTACK_INTERVAL = 1

    before_action :check_target_configuration
    around_action :prevent_timing_attack, only: :send_link

    # NOTE: Show input email form
    def new
    end

    def send_link
      AuthMaster::SendLinkOperation.call!(params[:email], target_scoped_class:)
      redirect_to auth_master_sent_url(target: target_param)
    end

    def sent
    end

    def link

    end

    private

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
  end
end
