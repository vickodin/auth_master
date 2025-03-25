module AuthMaster
  class Engine < ::Rails::Engine
    DEFAULT_LAYOUT = "application"

    isolate_namespace AuthMaster

    config.to_prepare do
      ApplicationController.layout ->(controller) {
        AuthMaster.targets[params[:target].to_sym][:layout] || DEFAULT_LAYOUT
      }
    end
  end
end
