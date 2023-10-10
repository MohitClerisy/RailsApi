# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_request
  def index
    @comments = Comment.all
                       .select(:id, :content, :post_id, :user_id, :created_at)
                       .includes(%i[user post])
                       .order(created_at: :desc)
                       .paginate(params[:page])
                       .per(params[:per_page])
    if @comments.count != 0
      render json: {
        pagination: pagination_data(@comments)
      }, status: :ok
    else
      render json: {
        errors: I18n.t('errors.not_found')
      }
    end
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = @current_user.id

    if @comment.save
      render json: {
               post: @comment,
               message: I18n.t('actions.create.success')
             },
             status: :created
    else
      render json: {
               errors: I18n.t('actions.create.error')
             },
             status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.find(params[:id])
    render json: @comment,
           status: :ok
  rescue StandardError => e
    render json: {
             message: e,
             errors: I18n.t('errors.invalid')
           },
           status: :unprocessable_entity
  end

  def update
    @comment = Comment.find_by(id: params[:id], user_id: @current_user.id)
    if @comment
      @comment.update(comment_params)
      render json: {
               comment: @comment,
               message: I18n.t('actions.update.success')
             },
             status: :ok
    else
      render json: {
               errors: I18n.t('actions.update.error')
             },
             status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.permit(:content, :user_id, :post_id)
  end
end
