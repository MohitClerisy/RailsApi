# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: ENV.fetch('EMAIL_FROM')
  def welcome_email
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def confirm_email(email_to, confirmation_token)
    base_url = ENV.fetch('BASE_URL')
    @confirmation_link = base_url + "/api/v1/auth/confirm-account?token=#{confirmation_token}"
    mail(to: email_to, subject: "Welcome to #{ENV.fetch('APP_NAME', 'Ruby on Rails')}!")
  end
end
