FactoryBot.define do
  factory :board do
    sequence(:title, "title_1")
    body { "body" }
    association :user
  end
end
