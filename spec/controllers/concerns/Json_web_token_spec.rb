# frozen_string_literal: true

require 'rails_helper'
require 'jwt'

RSpec.describe JsonWebToken do
  let(:user_id) { 1 }
  let(:payload) { { user_id: } }
  include JsonWebToken
  describe '#jwt_encode' do
    it 'encodes a payload into a JWT token' do
      token = jwt_encode(payload)
      decoded_payload = JWT.decode(token, JsonWebToken::SECRET_KEY, true).first

      expect(decoded_payload['user_id']).to eq(user_id)
      expect(decoded_payload['exp']).to be_present
    end
  end

  describe '#jwt_decode' do
    it 'decodes a JWT token into its original payload' do
      token = jwt_encode(payload)
      decoded_payload = jwt_decode(token)

      expect(decoded_payload[:user_id]).to eq(user_id)
    end
  end
end
