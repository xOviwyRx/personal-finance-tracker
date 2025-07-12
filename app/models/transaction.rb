class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category
  validates :amount, presence: true
  validates :transaction_type, presence: true
  before_validation :set_default_date, on: :create
  scope :income, -> { where(transaction_type: 'income') }
  scope :expense, -> { where(transaction_type: 'expense') }

  private

  def set_default_date
    self.date ||= Date.current
  end
end