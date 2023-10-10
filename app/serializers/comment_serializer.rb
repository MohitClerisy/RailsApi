# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :post_id, :user_id, :created_at
  belongs_to :user
  belongs_to :post
end
