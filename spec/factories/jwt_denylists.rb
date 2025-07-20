FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-07-20 20:26:43" }
  end
end
