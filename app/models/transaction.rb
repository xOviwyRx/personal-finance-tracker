class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :amount, presence: true
  validates :transaction_type, presence: true, inclusion: { in: %w[income expense] }
  validates :title, presence: true

  before_validation :set_default_date, on: :create

  validate :category_belongs_to_user

  scope :expenses, -> { where(transaction_type: 'expense') }
  scope :current_month, -> {
    where(date: Date.current.beginning_of_month..Date.current.end_of_month)
  }

  def expense?
    transaction_type == 'expense'
  end

  def budget_warnings(transaction)
    budget = user.budgets.find_by(category: transaction.category, month: Date.current.beginning_of_month)
    return [] unless budget

    total_category_expenses = user.transactions
                                          .expenses
                                          .current_month
                                          .where(category: transaction.category)
                                          .sum(:amount)

    warnings = []
    if total_category_expenses > budget.monthly_limit
      warnings << "You have exceeded the budget limit for category '#{transaction.category.name}' by #{total_category_expenses - budget.monthly_limit}."
    elsif total_category_expenses == budget.monthly_limit
      warnings << "You've reached the budget limit for category #{transaction.category.name}"
    elsif total_category_expenses > budget.monthly_limit * 0.75
      warnings << "You're approaching your budget limit for category '#{transaction.category.name}'."
    end

    warnings
  end

  private

  def set_default_date
    self.date ||= Date.current
  end

  def category_belongs_to_user
    if category&.user != user
      errors.add(:category, "must belong to the same user")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title amount date transaction_type]
  end
end