class UsersController < ApplicationController
    # include Services::Payment
    def my_profile
        begin
            # MyResqueJob.set(wait: 1.week).perform_later
            render json: @current_user,
            status: :ok
            Services::Payment::SubmitPayment.new
        rescue ActiveRecord::RecordNotFound => e
            render json:{
                error: e
            },
            status: :unprocessable_entity
            Services::Payment::CancelPayment.new
        end
    end
end
