FactoryBot.define do
  factory :transaction do
    title { 'Scrambled eggs' }
    date { Date.current }
    amount { 10.0 }
    transaction_type { 'expense' }
    user
    category { association :category, user: user }

    trait :income do
      transaction_type { 'income' }
    end

    trait :expense do
      transaction_type { 'expense' }
    end
  end
end
