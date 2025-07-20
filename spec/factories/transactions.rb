FactoryBot.define do
  factory :transaction do
    title { 'Scrambled eggs' }
    date { Date.current }
    amount { 10.0 }
    transaction_type { 'expense' }
    association :user
    association :category
  end
end