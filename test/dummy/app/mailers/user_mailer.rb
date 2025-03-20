class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.login_link.subject
  #

  def login_link
    @email = params[:email]
    @token = params[:token]

    mail(to: @email)
  end
end
