FactoryBot.define do
  factory :comment do
    user
    post
    content { "Test Comment" }
  end
end