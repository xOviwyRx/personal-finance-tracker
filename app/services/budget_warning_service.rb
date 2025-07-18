# frozen_string_literal: true

class BudgetWarningService
  APPROACHING_THRESHOLD = 0.75
  def initialize(transaction)
    @transaction = transaction
    @user = transaction.user
    @category = transaction.category
  end

  def generate_warnings
    return [] unless @transaction.expense?

    budget = find_current_budget
    return [] unless budget

    total_expenses = calculate_total_category_expenses
    build_warnings(budget, total_expenses)
  end

  private

  def find_current_budget
    @user.budgets.find_by(
      category: @category,
      month: Date.current.beginning_of_month
    )
  end

  def calculate_total_category_expenses
    @user.transactions
         .expenses
         .current_month
         .where(category: @category)
         .sum(:amount)
  end

  def build_warnings(budget, total_expenses)
    warnings = []

    if total_expenses > budget.monthly_limit
      excess = total_expenses - budget.monthly_limit
      warnings << "You have exceeded the budget limit for category '#{@category.name}' by #{excess}."
    elsif total_expenses == budget.monthly_limit
      warnings << "You've reached the budget limit for category '#{@category.name}'."
    elsif total_expenses > budget.monthly_limit * APPROACHING_THRESHOLD
      warnings << "You're approaching your budget limit for category '#{@category.name}'."
    end

    warnings
  end
end
