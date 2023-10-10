# frozen_string_literal: true

require 'swagger_helper'
require 'jwt'

RSpec.describe 'users', type: :request do
  include JsonWebToken

  path '/api/v1/user/my-profile' do
    get('Retrieve user profile') do
      consumes 'application/json'
      security [BearerAuth: []]

      let(:user) { create(:user) }

      let(:valid_token) { "Bearer #{jwt_encode({ user_id: user.id })}" }

      let(:invalid_token) { "Bearer #{jwt_encode(user_id: user.id, exp: 5.minute.ago.to_i)}" }

      let(:Authorization) { valid_token }

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

      # response(401, 'unauthorized') do
      #   let(:'Authorization') { invalid_token }

      #   run_test!
      # end
    end
  end
end
