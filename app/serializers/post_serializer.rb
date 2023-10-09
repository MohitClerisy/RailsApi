class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :user_id, :created_at, :updated_at
  belongs_to :user
end
