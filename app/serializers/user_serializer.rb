# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :username, :created_at, :updated_at
  has_many :posts
end
