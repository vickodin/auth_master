require "test_helper"
require "token_guard"

module AuthMaster
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include AuthMaster::Config

    # NOTE: action new
    test "login works for user" do
      get auth_master_login_url(target: :user)
      assert_response :success
    end

    test "login works for admin" do
      get auth_master_login_url(target: :admin)
      assert_response :success
    end

    test "login does not work for superviser" do
      get auth_master_login_url(target: :superviser)
      assert_response :not_found
    end

    test "login works for manager" do
      get auth_master_login_url(target: :manager)
      assert_response :success
    end

    # NOTE: action create
    test "create makes session for user" do
      email = "new@user.email"
      user = User.create!(email:)

      assert_difference("AuthMaster::Session.count", 1) do
        post auth_master_login_url(target: :user), params: { email: }
      end

      assert_response :redirect

      auth_master_session = AuthMaster::Session.inactive.where(target: user).first!
      assert auth_master_session.present?
    end

    test "create skips for not registered user" do
      email = "new@user.email"

      assert_difference("AuthMaster::Session.count", 0) do
        post auth_master_login_url(target: :user), params: { email: }
      end

      assert_response :redirect
    end

    test "create works for manager" do
      email   = "new@user.email"
      company = Company.create!(name: "Company")
      manager = Manager.create!(email:, company:)

      assert_difference("AuthMaster::Session.count", 1) do
        post auth_master_login_url(target: :manager), params: { email: }
      end

      assert_response :redirect

      auth_master_session = AuthMaster::Session.inactive.where(target: manager).first!
      assert auth_master_session.present?
    end

    # NOTE: action sent
    test "sent works" do
      get auth_master_sent_url(target: :user)
      assert_response :success
    end

    # NOTE: action link
    test "link works" do
      # NOTE: Prepare session
      email = "new@user.email"
      user = User.create!(email:)
      post auth_master_login_url(target: :user), params: { email: }

      # NOTE: try action with some token
      get auth_master_link_url(target: :user, token: :xyz)
      assert_response :success
    end

    test "activate works" do
      # NOTE: Prepare session
      email = "new@user.email"
      user = User.create!(email:)
      post auth_master_login_url(target: :user), params: { email: }

      # NOTE: Prepare token
      auth_master_session = AuthMaster::Session.inactive.where(target: user).last!
      secret = AuthMaster.targets[:user][:secret]
      token = TokenGuard.encrypt(auth_master_session.id, purpose: token_purpose_config(:user), secret: secret_config(:user))

      post auth_master_link_url(target: :user), params: { token: }
      assert_response :redirect

      auth_master_session.reload
      assert auth_master_session.active?
    end

    test "destroy makes session's state eq logout" do
      # NOTE: Prepare session
      email = "new@user.email"
      user = User.create!(email:)
      post auth_master_login_url(target: :user), params: { email: }

      # NOTE: Prepare token
      auth_master_session = AuthMaster::Session.inactive.where(target: user).last!
      secret = AuthMaster.targets[:user][:secret]
      token = TokenGuard.encrypt(auth_master_session.id, purpose: token_purpose_config(:user), secret: secret_config(:user))

      post auth_master_link_url(target: :user), params: { token: }
      auth_master_session.reload
      assert auth_master_session.active?

      delete auth_master_logout_url(target: :user)
      assert_response :redirect

      auth_master_session.reload
      assert auth_master_session.logout?
    end
  end
end
