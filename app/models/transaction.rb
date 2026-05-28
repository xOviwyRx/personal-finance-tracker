class Transaction < ApplicationRecord
  include CategoryOwnership

  belongs_to :user
  belongs_to :category
  belongs_to :recurring_transaction, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[income expense] }
  validates :title, presence: true

  before_validation :set_default_date, on: :create

  after_commit :enqueue_budget_alert, on: [:create, :update]

  scope :expenses, -> { where(transaction_type: 'expense') }
  scope :current_month, -> {
    where(date: Date.current.all_month)
  }

  def expense?
    transaction_type == 'expense'
  end

  private

  def enqueue_budget_alert
    BudgetAlertJob.perform_later(id)
  end

  def set_default_date
    self.date ||= Date.current
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title amount date transaction_type]
  end
end
