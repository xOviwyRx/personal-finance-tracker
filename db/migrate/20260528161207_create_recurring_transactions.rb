class CreateRecurringTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :recurring_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :title, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string :transaction_type, null: false
      t.date :start_on, null: false
      t.date :next_run_on, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :recurring_transactions, :next_run_on
    add_check_constraint :recurring_transactions, "amount > 0", name: "recurring_transactions_amount_positive"
    add_check_constraint :recurring_transactions, "transaction_type IN ('income', 'expense')", name: "recurring_transactions_type_check"
  end
end
