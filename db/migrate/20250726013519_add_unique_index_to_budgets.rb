class AddUniqueIndexToBudgets < ActiveRecord::Migration[7.1]
  def up
    add_index :budgets, [:user_id, :category_id, :month], unique: true
  end

  def down
    remove_index :budgets, [:user_id, :category_id, :month]
  end
end
