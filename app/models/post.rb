# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, presence: true
  validates :description, presence: true
end
