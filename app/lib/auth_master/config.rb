module AuthMaster
  module Config
    DEFAULT_LOGIN_TIMEOUT_INTERVAL  = 5.minutes
    DEFAULT_LOGIN_ATTEMPTS_COUNT    = 3
    DEFAULT_TOKEN_PURPOSE           = :auth_master_email

    def login_timeout_interval_config(target)
      config_for(target, :login_timeout_interval) || DEFAULT_LOGIN_TIMEOUT_INTERVAL
    end

    def login_attempts_count_config(target)
      config_for(target, :login_attempts_count) || DEFAULT_LOGIN_ATTEMPTS_COUNT
    end

    def token_purpose_config(target)
      config_for(target, :token_purpose) || DEFAULT_TOKEN_PURPOSE
    end

    def secret_config(target)
      config_for(target, :secret)
    end

    def target_mailer_config(target)
      config_for(target, :mailer_class).to_s.classify.constantize
    end

    def target_mailer_login_link_method(target)
      config_for(target, :mailer_login_link_method)
    end

    def target_name(target)
      return target if target.is_a? Symbol
      return target.to_sym if target.is_a? String

      target.class.to_s.underscore.to_sym
    end

    def config_for(target, name)
      AuthMaster.targets[target_name(target)][name.to_sym]
    end
  end
end
