module AuthMaster
  class ApplicationController < ActionController::Base
    # NOTE: Ability to use main app url helpers from main app's layout
    helper Rails.application.routes.url_helpers
    helper_method :target_route

    def target_scoped_class
      target_scope = config_for(:scope)
      target_scope.present? ? target_accessor.send(target_scope) : target_accessor
    end

    private

    def target_accessor
      finder = config_for(:finder)
      finder.is_a?(Proc) ? finder.call : target_class
    end

    def target_class
      target_param.to_s.classify.constantize
    end

    def target_param
      params[:target].to_sym
    end

    def target_param_name
      params[:target].to_sym
    end

    def target_route
      config_for(:route) || :auth_master
    end

    def config_for(name)
      AuthMaster.targets[target_param][name.to_sym]
    end

    def check_target_configuration
      raise ActionController::RoutingError.new("Not Found Target Config") if AuthMaster.targets[target_param].blank?
    end
  end
end
