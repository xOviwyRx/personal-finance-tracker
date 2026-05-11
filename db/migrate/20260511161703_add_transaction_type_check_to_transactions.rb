class AddTransactionTypeCheckToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :transactions,
                         "transaction_type IN ('income', 'expense')",
                         name: "transactions_type_check"
  end
end
