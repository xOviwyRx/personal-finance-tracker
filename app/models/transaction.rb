class Transaction < ApplicationRecord
  belongs_to :category
  validates :amount, presence: true
  scope :income, -> { where(transaction_type: 'income') }
  scope :expense, -> { where(transaction_type: 'expense') }
end