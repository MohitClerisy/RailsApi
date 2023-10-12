# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'posts', type: :request do
  include JsonWebToken
  let(:user) { create(:user) }

  let(:valid_token) { "Bearer #{jwt_encode({ user_id: user.id })}" }

  let(:invalid_token) { "Bearer #{jwt_encode(user_id: user.id, exp: 5.minute.ago.to_i)}" }
  path '/api/v1/posts' do
    get('list posts') do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :page, in: :query, type: :integer, description: 'Page number (default: 1)'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page (default: 10)'

      response(200, 'successful') do
        let(:Authorization) { valid_token }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create post') do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string }
        },
        required: %w[title description]
      }
      response(200, 'successful') do
        let(:Authorization) { valid_token }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/posts/{id}' do
    # You'll want to customize the parameter types...
    get('show post') do
      parameter name: 'id', in: :path, type: :string, description: 'id'
      consumes 'application/json'
      security [BearerAuth: []]

      response(200, 'successful') do
        let(:Authorization) { valid_token }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    patch('update post') do
      parameter name: 'id', in: :path, type: :string, description: 'id'
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string }
        },
        required: %w[title description]
      }
      response(200, 'successful') do
        let(:Authorization) { valid_token }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('update post') do
      parameter name: 'id', in: :path, type: :string, description: 'id'
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string }
        },
        required: %w[title description]
      }
      response(200, 'successful') do
        let(:Authorization) { valid_token }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete post') do
      parameter name: 'id', in: :path, type: :string, description: 'id'
      security [BearerAuth: []]
      response(200, 'successful') do
        let(:Authorization) { valid_token }

        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
