# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'comments', type: :request do
  include JsonWebToken
  let(:user) { create(:user) }

  let(:valid_token) { "Bearer #{jwt_encode({ user_id: user.id })}" }

  let(:invalid_token) { "Bearer #{jwt_encode(user_id: user.id, exp: 5.minute.ago.to_i)}" }
  path '/api/v1/posts/{post_id}/comments' do
    # You'll want to customize the parameter types...
    parameter name: 'post_id', in: :path, type: :string, description: 'post_id'

    get('list comments') do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :page, in: :query, type: :integer, description: 'Page number (default: 1)'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page (default: 10)'
      response(200, 'successful') do
        let(:Authorization) { valid_token }
        let(:post_id) { '123' }

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

    post('create comment') do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: 'post_id', in: :path, type: :string, description: 'post_id'
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string }
        },
        required: ['content']
      }
      response(200, 'successful') do
        let(:Authorization) { valid_token }
        let(:post_id) { '123' }

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

  path '/api/v1/comments/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show comment') do
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

    patch('update comment') do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string }
        },
        required: %w[content]
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

    put('update comment') do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string }
        },
        required: %w[content]
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

    delete('delete comment') do
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
  end
end
