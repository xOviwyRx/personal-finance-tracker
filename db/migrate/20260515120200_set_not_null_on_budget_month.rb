class SetNotNullOnBudgetMonth < ActiveRecord::Migration[7.1]
  def up
    change_column_null :budgets, :month, false
  end

  def down
    change_column_null :budgets, :month, true
  end
end
