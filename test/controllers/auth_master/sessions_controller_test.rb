require "test_helper"

module AuthMaster
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

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

    # NOTE: action send_link
    test "send_link works for user" do
      email = "new@user.email"
      user = User.create!(email:)

      assert_difference("AuthMaster::Session.count", 1) do
        post auth_master_login_url(target: :user), params: { email: }
      end

      assert_response :redirect

      auth_master_session = AuthMaster::Session.inactive.where(target: user).first!
      assert auth_master_session.present?
    end

    test "send_link works for not registered user" do
      email = "new@user.email"

      assert_difference("AuthMaster::Session.count", 0) do
        post auth_master_login_url(target: :user), params: { email: }
      end

      assert_response :redirect
    end

    test "send_link works for manager" do
      email   = "new@user.email"
      company = Company.create!(name: "Company")
      manager = Manager.create!(email:, company:)

      assert_difference("AuthMaster::Session.count", 1) do
        post auth_master_login_url(target: :manager), params: { email: }
      end

      assert_response :redirect

      auth_master_session = AuthMaster::Session.where(target: manager).first!
      assert auth_master_session.present?
    end

    # NOTE: action sent
    test "sent works" do
      get auth_master_sent_url(target: :user)
      assert_response :success
    end
  end
end
