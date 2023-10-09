class AuthenticationController < ApplicationController
    include JsonWebToken
    skip_before_action :authenticate_request, only: [:login, :register]

    def login
        Rails.logger.silence do
            @user = User.find_by_email(params[:email])
            if(@user&.authenticate(params[:password]))
                exp_time = Time.now + ENV.fetch('JWT_TOKEN_EXPIRATION', 3600).to_i
                token = jwt_encode({user_id: @user.id}, exp_time.to_i)
                render json: {
                    token: token,
                    exp_time: exp_time
                },
                status: :ok
            else
                render json: {
                    error: "Invalid Email or password"
                },
                status: :unauthorized
            end
        end
    end

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
        params.permit(:name,:username,:email,:password)
    end
end
