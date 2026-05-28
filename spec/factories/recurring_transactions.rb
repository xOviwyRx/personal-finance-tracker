FactoryBot.define do
  factory :recurring_transaction do
    title { 'Rent' }
    amount { 1200.0 }
    transaction_type { 'expense' }
    start_on { Date.current }
    user
    category { association :category, user: user }
  end
end
