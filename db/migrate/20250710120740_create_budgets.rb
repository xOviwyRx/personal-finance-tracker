class CreateBudgets < ActiveRecord::Migration[7.1]
  def change
    create_table :budgets do |t|
      t.decimal :monthly_limit
      t.date :month
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
