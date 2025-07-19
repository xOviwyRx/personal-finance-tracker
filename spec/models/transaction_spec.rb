require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }

  it 'has amount' do
    transaction = Transaction.new(amount: 10)
    expect(transaction.amount).to eq(10)
  end

  describe 'validations' do
    it 'is invalid without title' do
      transaction = Transaction.new(
        user: user,
        category: category,
        transaction_type: 'income',
        )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without amount' do
      transaction = Transaction.new(
        user: user,
        category: category,
        title: 'Roastbeef',
        transaction_type: 'income',
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include("can't be blank")
    end

    it 'is invalid without transaction_type' do
      transaction = Transaction.new(
        user: user,
        category: category,
        amount: 10,
        title: 'Roastbeef',
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:transaction_type]).to include("can't be blank")
    end

    it 'is invalid with wrong transaction type' do
      transaction = Transaction.new(
        user: user,
        category: category,
        amount: 10,
        transaction_type: 'wrong type',
        title: 'Roastbeef',
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:transaction_type]).to include("is not included in the list")
    end

    context 'category validations' do
      let(:user2) { create(:user) }
      let(:category2) { create(:category, user: user2) }

      it 'does create transaction with category of current user' do
        transaction = Transaction.new(
          user: user,
          category: category,
          amount: 10,
          title: 'Roastbeef',
          transaction_type: 'income',
          )
        expect(transaction).to be_valid
      end

      it 'does not create transaction with category of another user' do
        transaction = Transaction.new(
          user: user,
          category: category2,
          amount: 10,
          title: 'Roastbeef',
          transaction_type: 'income',
          )
        expect(transaction).not_to be_valid
        expect(transaction.errors[:category]).to include("must belong to the same user")
      end
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
      amount: 10,
      transaction_type: 'income',
      title: 'Roastbeef',
    )
    expect(transaction.date).to eq(Date.current)
  end
end
