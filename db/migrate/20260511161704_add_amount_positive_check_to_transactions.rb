class AddAmountPositiveCheckToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :transactions, "amount > 0",
                         name: "transactions_amount_positive"
  end
end
