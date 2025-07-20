FactoryBot.define do
  factory :budget do
    monthly_limit { 500.0 }
    month { Date.current }
    association :user
    association :category
  end
end