class UpdateTransactionConstraints < ActiveRecord::Migration[7.1]
  def change
    change_column :transactions, :title, :string, null: false
    change_column :transactions, :amount, :decimal, null: false
    change_column :transactions, :date, :date, null: false
    change_column :transactions, :transaction_type, :string, null: false
  end
end
