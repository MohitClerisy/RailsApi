# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    user
    title { 'New Post' }
    description { 'password123' }
  end
end
