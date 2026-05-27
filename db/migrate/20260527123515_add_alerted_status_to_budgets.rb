class AddAlertedStatusToBudgets < ActiveRecord::Migration[7.1]
  def change
    add_column :budgets, :alerted_status, :integer, default: 0, null: false
  end
end
