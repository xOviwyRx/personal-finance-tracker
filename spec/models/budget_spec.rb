require 'rails_helper'

RSpec.describe Budget, type: :model do
  it 'has monthly_limit' do
    budget = Budget.new(monthly_limit: 10)
    expect(budget.monthly_limit).to eq(10)
  end

  it 'is invalid without monthly_limit' do
    user = User.create(email: 'test@example.com', password: 'password123')
    category = Category.create(name: 'Food', user: user)

    budget = Budget.new(monthly_limit: nil, user: user, category: category)
    expect(budget).not_to be_valid
    expect(budget.errors[:monthly_limit]).to include("can't be blank")
  end

  it 'belongs to user' do
    expect(Budget.reflect_on_association(:user).macro).to eq(:belongs_to)
  end

  it 'belongs to category' do
    expect(Budget.reflect_on_association(:category).macro).to eq(:belongs_to)
  end
end
