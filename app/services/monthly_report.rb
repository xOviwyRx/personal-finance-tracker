class MonthlyReport
  def initialize(user:, month:)
    @user = user
    @month_start = month.beginning_of_month
    @range = month.all_month
  end

  def call
    totals = @user.transactions.where(date: @range).group(:transaction_type).sum(:amount)

    income = totals['income'] || 0
    expenses = totals['expense'] || 0

    category_breakdown = @user.transactions
                              .joins(:category)
                              .where(date: @range, transaction_type: 'expense')
                              .group('categories.name')
                              .sum(:amount)

    {
      month: @month_start.strftime('%Y-%m'),
      total_income: income,
      total_expenses: expenses,
      net: income - expenses,
      category_breakdown: category_breakdown
    }
  end
end
