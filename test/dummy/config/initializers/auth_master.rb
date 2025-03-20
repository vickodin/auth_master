AuthMaster.configure do |config|
  # config.mailer_class = 'UserMailer'
  # config.mailer_login_link_method = 'login_link'
  # config.target_scope = :active
  # config.secret = SecureRandom.hex(16)

  # Use 0 to disable
  # config.timing_attack_interval = 0
  config.timing_attack_interval = 0.5

  config.targets = {
    # NOTE: Basic example
    # `current_user = User.active.find_by(email: "user@email.address")`
    user: {
      mailer_class: "UserMailer",
      mailer_login_link_method: "login_link",
      scope: :active,
      secret: SecureRandom.hex(16),
      login_timeout_interval: 5.minutes,
      login_attempts_count: 3
    },
    # NOTE: Another namespace
    # `current_admin = Admin.active.find_by(email: "admin@email.address")`
    admin: {
      mailer_class: "AdminMailer",
      mailer_login_link_method: "login_link",
      scope: :active,
      secret: SecureRandom.hex(16),
      login_timeout_interval: 10.minutes,
      login_attempts_count: 2
    },
    # NOTE: When we need base scope, e.g.:
    # `current_manager = Company.find_by!(host: request.host).active_managers.find_by(email: "manager@email.address")`
    manager: {
      mailer_class: "UserMailer",
      mailer_login_link_method: "login_link",
      finder: lambda { Company.find_by!(name: "Company") },
      scope: :active_managers,
      secret: SecureRandom.hex(16),
      login_timeout_interval: 5.minutes,
      login_attempts_count: 3
    }
  }
end
