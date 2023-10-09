require 'rails_helper'

RSpec.describe Setting, type: :model do
    describe 'default values' do
        it 'sets default values correctly' do
            expect(Setting.app_name).to eq('Rails Settings')
            expect(Setting.host).to eq('http://example.com')
            expect(Setting.default_locale).to eq('en-US')
            expect(Setting.admin_emails).to eq(%w[admin@rubyonrails.org])
            expect(Setting.welcome_message).to eq("welcome to Rails Settings")
            expect(Setting.tips).to eq(["Setting"])
            expect(Setting.user_limits).to eq(20)
            expect(Setting.exchange_rate).to eq(0.123)
            expect(Setting.captcha_enable).to be true
            expect(Setting.notification_options).to eq({
                send_all: true,
                logging: true,
                sender_email: "foo@bar.com"
            })
            expect(Setting.readonly_item).to eq(100)
        end
    end
end
