class PostsController < ApplicationController
    before_action :authenticate_request
    def index 
        @posts = Post.all
                    .select(:id, :title, :description, :user_id, :created_at)
                    .includes(:user)
                    .order(created_at: :desc)
                    .paginate(params[:page])
                    .per(params[:per_page])
        render json: {
            pagination: pagination_data(@posts)
        }
    end
    def create
        @post = Post.new(post_params)
        @post.user_id = @current_user.id
        begin
            if @post.save
                render json: {
                    post: @post
                },
                status: :created
            else
                render json: {
                    errors: I18n.t('actions.create.error')
                },
                status: :unprocessable_entity
            end
        rescue => e
            puts e.message
            puts e.backtrace.inspect
        end
    end
    def show
        begin
            @post = Post.find(params[:id])
            render json: @post
        rescue =>e
            render json: {
                errors:e
            }
        end
        
        
    end

    def update
        @post = Post.find_by(id: params[:id], user_id: @current_user.id)
        if @post
            @post.update(post_params)
            render json: {
                post: @post,
                message: I18n.t('actions.update.success')
            },
            status: :ok
        else
            render json: {
                errors: 'Not Found',
                message: I18n.t('actions.update.error')
            },
            status: :unprocessable_entity
        end
    end

    private
    def post_params
        params.permit(:title,:description,:user_id)
    end
end
