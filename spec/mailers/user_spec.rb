require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'welcome_email' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.with(user: user).welcome_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('Welcome to My Awesome Site')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([ENV.fetch('EMAIL_FROM')])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('http://example.com/login')
    end
  end
end
