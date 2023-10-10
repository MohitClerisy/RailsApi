# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'authentication', type: :request do
  path '/api/v1/auth/register' do
    post('register authentication') do
      consumes 'application/json'
      parameter name: :register, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          username: { type: :string },
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[username email password]
      }

      # Declare the parameters for the request
      let(:register) do
        {
          name: 'John Doe',
          username: 'johndoe1',
          email: 'john.doe1@example.com',
          password: 'password123'
        }
      end

      response(201, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end
      response(422, 'unprocessable_entity') do
        let(:register) do
          {
            name: '',
            username: '',
            email: 'john.doe1@example.com',
            password: 'password123'
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/auth/login' do
    post('login authentication') do
      consumes 'application/json'
      parameter name: :login, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      # Declare the parameters for the request
      let(:login) do
        {
          email: 'johndoe1@example.com',
          password: 'password123'
        }
      end

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end
      response(401, 'unauthorized') do
        let(:login) do
          {
            email: 'johndoe@example.com',
            password: 'password123'
          }
        end
        run_test!
      end
    end
  end
end
