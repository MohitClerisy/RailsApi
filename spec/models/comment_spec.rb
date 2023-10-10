# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post) }
    let(:comment) { FactoryBot.build(:comment, user:, post:) }

    it 'belongs to user' do
      expect(comment.user).to eq(user)
    end

    it 'belongs to post' do
      expect(comment.post).to eq(post)
    end
  end
end
