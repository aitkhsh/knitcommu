FactoryBot.define do
  factory :user do
    name { "あい" }
    sequence(:email) { |n| "user_#{n}@example.com"}
    password { "password" }
    password_confirmation { "password" }
  end
end