class RecurringTransaction < ApplicationRecord
  include CategoryOwnership

  belongs_to :user
  belongs_to :category
  has_many :transactions, dependent: :nullify

  before_validation :set_next_run_on, on: :create

  validates :title, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[income expense] }
  validates :start_on, presence: true,
                       comparison: { greater_than_or_equal_to: -> { Date.current } }, on: :create

  scope :due, -> { where(active: true).where(next_run_on: ..Date.current) }

  def next_transaction_date(date)
    month = date.next_month
    day = [start_on.day, month.end_of_month.day].min
    month.change(day: day)
  end

  def next_future_run
    date = next_run_on
    date = next_transaction_date(date) until date > Date.current
    date
  end

  private

  def set_next_run_on
    self.next_run_on ||= start_on
  end
end
