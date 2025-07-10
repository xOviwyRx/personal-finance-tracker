class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :title
      t.decimal :amount
      t.date :date
      t.string :transaction_type
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
