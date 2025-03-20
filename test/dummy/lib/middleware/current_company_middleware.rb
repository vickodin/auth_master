# TODO: Add use case
# NOTE: Middleware example
class CurrentCompanyMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    env["current_company_id"] = Company.first&.id
    @app.call(env)
  end
end
