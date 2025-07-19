FactoryBot.define do
  factory :category do
    name { 'Food' }
    association :user
  end
end
