# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  require 'resque/server'
  mount Resque::Server, at: '/jobs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope :api do
    scope :v1 do
      scope :auth do
        post 'register', to: 'authentication#register'
        post 'login', to: 'authentication#login'
      end
      scope :user do
        get 'my-profile', to: 'users#my_profile'
      end
      resources :posts, shallow: true do
        resources :comments
      end
    end
  end
end
