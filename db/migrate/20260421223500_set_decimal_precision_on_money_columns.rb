class SetDecimalPrecisionOnMoneyColumns < ActiveRecord::Migration[7.1]
  def up
    change_column :transactions, :amount, :decimal, precision: 12, scale: 2, null: false
    change_column :budgets, :monthly_limit, :decimal, precision: 12, scale: 2
  end

  def down
    change_column :transactions, :amount, :decimal, null: false
    change_column :budgets, :monthly_limit, :decimal
  end
end
