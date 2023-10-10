# frozen_string_literal: true

class AuthenticationController < ApplicationController
  include JsonWebToken
  skip_before_action :authenticate_request, only: %i[login register]
  # Logs in a user and returns a JSON response containing a token and an expiration time.
  # @param params [Hash] - A hash containing the user's email and password.
  #   - email [String] - The user's email.
  #   - password [String] - The user's password.
  # @return [JSON] - A JSON response containing a token and an expiration time.
  #   - token [String] - The JWT token for the authenticated user.
  #   - exp_time [Time] - The expiration time for the token.

  def login
    Rails.logger.silence do
      @user = User.find_by_email(params[:email])
      if @user&.authenticate(params[:password])
        exp_time = Time.now + ENV.fetch('JWT_TOKEN_EXPIRATION', 3600).to_i
        token = jwt_encode({ user_id: @user.id }, exp_time.to_i)
        render json: {
                 token:,
                 exp_time:
               },
               status: :ok
      else
        render json: {
                 error: 'Invalid Email or password'
               },
               status: :unauthorized
      end
    end
  end

  def login
    Rails.logger.silence do
      @user = User.find_by_email(params[:email])
      if @user&.authenticate(params[:password])
        exp_time = Time.now + ENV.fetch('JWT_TOKEN_EXPIRATION', 3600).to_i
        token = jwt_encode({ user_id: @user.id }, exp_time.to_i)
        render json: {
                 token:,
                 exp_time:
               },
               status: :ok
      else
        render json: {
                 error: 'Invalid Email or password'
               },
               status: :unauthorized
      end
    end
  end

  # This function registers a new user.
  # It creates a new User object using the user_params provided.
  # If the user is successfully saved, a welcome email is sent to the user using UserMailer.
  # The function then returns a JSON response with the user object and a success message,
  # and sets the response status to "created" (201).
  # If the user fails to save, an error JSON response is returned with an error message,
  # and the response status is set to "unprocessable_entity" (422).
  def register
    Rails.logger.silence do
      @user = User.new(user_params)

      if @user.save
        UserMailer.with(user: @user).welcome_email.deliver
        render json: {
                 user: @user,
                 message: I18n.t('actions.create.success')
               },
               status: :created
      else
        render json: {
                 error: :unprocessable_entity,
                 message: I18n.t('actions.create.error')
               },
               status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.permit(:name, :username, :email, :password)
  end
end
