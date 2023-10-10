# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :user_id, :created_at
  belongs_to :user
end
