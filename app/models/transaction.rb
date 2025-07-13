class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :amount, presence: true
  validates :transaction_type, presence: true, inclusion: { in: %w[income expense] }

  before_validation :set_default_date, on: :create

  private

  def set_default_date
    self.date ||= Date.current
  end
end