# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    sequence(:username) { |n| "johndoe#{n}" }
    sequence(:email) { |n| "johndoe#{n}@example.com" }
    password { 'password123' }
  end
end
