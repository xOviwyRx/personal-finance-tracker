FactoryBot.define do
  factory :budget do
    monthly_limit { 500.0 }
    month { Date.current.beginning_of_month }
    user
    category { association :category, user: user }
  end
end
