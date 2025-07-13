require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password') }
  let(:category) { Category.create(name: 'Food', user: user) }

  it 'has amount' do
    transaction = Transaction.new(amount: '10')
    expect(transaction.amount).to eq(10)
  end

  describe 'validations' do
    it 'is invalid without amount' do
      transaction = Transaction.new(
        user: user,
        category: category,
        transaction_type: 'income',
      )
      expect(transaction).not_to be_valid
    end

    it 'is invalid without transaction_type' do
      transaction = Transaction.new(
        user: user,
        category: category,
        amount: '10',
      )
      expect(transaction).not_to be_valid
    end

    it 'is invalid with wrong transaction type' do
      transaction = Transaction.new(
        user: user,
        category: category,
        amount: '10',
        transaction_type: 'wrong type',
      )
      expect(transaction).not_to be_valid
    end
  end

  it 'belongs to user' do
    expect(Transaction.reflect_on_association(:user).macro).to eq(:belongs_to)
  end

  it 'belongs to category' do
    expect(Transaction.reflect_on_association(:category).macro).to eq(:belongs_to)
  end

  it 'sets default date on create' do
    transaction = Transaction.create(
      user: user,
      category: category,
      amount: '10',
      transaction_type: 'income',
    )
    expect(transaction.date).to eq(Date.current)
  end
end
