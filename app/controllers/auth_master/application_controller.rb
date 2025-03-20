module AuthMaster
  class ApplicationController < ActionController::Base
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

    def config_for(name)
      AuthMaster.targets[target_param][name.to_sym]
    end

    def check_target_configuration
      raise ActionController::RoutingError.new("Not Found") if AuthMaster.targets[target_param].blank?
    end
  end
end
