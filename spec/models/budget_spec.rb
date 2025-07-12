require 'rails_helper'

RSpec.describe Budget, type: :model do
  it 'has monthly_limit' do
    budget = Budget.new(monthly_limit: 10)
    expect(budget.monthly_limit).to eq(10)
  end

  it 'is invalid without monthly_limit' do
    budget = Budget.new(monthly_limit: nil)
    expect(budget).not_to be_valid
  end

  it 'belongs to user' do
    expect(Budget.reflect_on_association(:user).macro).to eq(:belongs_to)
  end

  it 'belongs to category' do
    expect(Budget.reflect_on_association(:category).macro).to eq(:belongs_to)
  end
end
