# frozen_string_literal: true

class AuthenticationController < ApplicationController
  include JsonWebToken
  skip_before_action :authenticate_request, only: %i[login register confirm_account]
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
        if @user.is_verified.nil? || @user.is_verified
          exp_time = Time.now + ENV.fetch('JWT_TOKEN_EXPIRATION', 3600).to_i
          token = jwt_encode({ user_id: @user.id }, exp_time.to_i)
          render json: {
                   token:,
                   exp_time:
                 },
                 status: :ok
        else
          render json: {
                   error: I18n.t('auth.unconfirmed')
                 },
                 status: :unauthorized
        end
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
      @user.is_verified = false
      if @user.save
        # UserMailer.with(user: @user).welcome_email.deliver
        @confirmation_token = jwt_encode({ user_id: @user.id, exp: 24.hours.from_now.to_i })
        UserMailer.confirm_email(@user.email, @confirmation_token).deliver
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

  # Confirm user account
  #
  # This method is used to confirm a user account by verifying the provided token. It decodes the token,
  # finds the corresponding user, and updates the user's verification status to true. If the user is successfully
  # verified, it returns a JSON response with a success message and a status of 200. If the user is not found or
  # already verified, it returns a JSON response with an error message and a status of 401.
  #
  # Params:
  # - token: A string representing the token used for account verification.
  #
  # Returns:
  # - A JSON response with a success or error message and the corresponding HTTP status code.
  #
  def confirm_account
    Rails.logger.silence do
      decoded_user = jwt_decode(params[:token])
      @user = User.find_by(id: decoded_user['user_id'])
      if @user && !@user.is_verified
        User.where(id: @user.id).update_all(is_verified: true)
        render json: {
          message: I18n.t('auth.confirmed')
        }, status: :ok
      elsif @user.is_verified
        render json: {
          error: I18n.t('auth.already_confirmed')
        }, status: :unauthorized
      end
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      raise I18n.t('auth.expired')
    end
  end

  private

  def user_params
    params.permit(:name, :username, :email, :password)
  end
end
