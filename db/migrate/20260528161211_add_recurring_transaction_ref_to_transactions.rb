class AddRecurringTransactionRefToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_reference :transactions, :recurring_transaction, null: true, index: false,
                                                         foreign_key: { on_delete: :nullify }
    add_index :transactions, [:recurring_transaction_id, :date],
              unique: true, where: "recurring_transaction_id IS NOT NULL",
              name: "index_transactions_on_recurring_rule_and_date"
  end
end
