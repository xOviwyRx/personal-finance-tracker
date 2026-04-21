class AddNotNullToBudgetMonthlyLimit < ActiveRecord::Migration[7.1]
  def change
    change_column_null :budgets, :monthly_limit, false
  end
end
