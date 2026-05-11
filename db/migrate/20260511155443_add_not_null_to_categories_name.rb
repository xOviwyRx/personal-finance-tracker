class AddNotNullToCategoriesName < ActiveRecord::Migration[7.1]
  def up
    execute "UPDATE categories SET name = 'Untitled' WHERE name IS NULL"
    change_column_null :categories, :name, false
  end

  def down
    change_column_null :categories, :name, true
  end
end
