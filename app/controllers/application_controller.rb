class ApplicationController < ActionController::API
    include JsonWebToken
    before_action :authenticate_request,:set_locale
    
    def set_locale
        locale = request.headers["Accept-Language"]&.split(',')&.first&.split('-')&.first
        I18n.locale = params[:locale] || locale || I18n.default_locale
    end

    private
    def authenticate_request
        begin
            header = request.headers['Authorization']
            token = header.split(" ").last if header
            decoded = jwt_decode(token)
            @current_user = User.includes(:posts).find(decoded[:user_id]) 
        rescue => e
            render json:{
                error: e
            },
            status: :unauthorized
        end
    end
    
    # Method to render pagination data
    def pagination_data(model)
        {   rows:ActiveModel::SerializableResource.new(model),
            total_pages: model.total_pages,
            current_page: model.current_page,
            next_page: model.next_page,
            prev_page: model.prev_page,
            total_count: model.total_count,
            limit_value: model.limit_value
        }
    end
end