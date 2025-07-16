class AddUserCategoryDateTypeIndexToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_index :transactions, [:user_id, :category_id, :date, :transaction_type], name: 'index_transactions_on_user_category_date_and_type'
  end
end
