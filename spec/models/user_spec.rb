require 'rails_helper'

RSpec.describe User, type: :model do
  # Test basic Devise integration
  it 'is valid with email and password' do
    user = User.new(email: 'text@example.com', password: 'password')
    expect(user).to be_valid
  end

  it 'is invalid without email' do
    user = User.new(password: 'password')
    expect(user).not_to be_valid
  end

  it 'duplicate email' do
    User.create(email: 'test@example.com', password: 'password')
    user2 = User.new(email: 'test@example.com', password: 'password')
    expect(user2).not_to be_valid
  end

  it 'is invalid without password' do
    user = User.new(email:'text@example.com')
    expect(user).not_to be_valid
  end

  # Test associations
  it 'has many categories' do
    expect(User.reflect_on_association(:categories).macro).to eq(:has_many)
  end

  it 'has many budgets' do
    expect(User.reflect_on_association(:budgets).macro).to eq(:has_many)
  end

  it 'has many transactions' do
    expect(User.reflect_on_association(:transactions).macro).to eq(:has_many)
  end
end
