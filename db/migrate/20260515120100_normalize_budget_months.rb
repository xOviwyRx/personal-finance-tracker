class NormalizeBudgetMonths < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL.squish
      DELETE FROM budgets
      WHERE id NOT IN (
        SELECT MIN(id)
        FROM budgets
        GROUP BY user_id, category_id, date_trunc('month', month)
      )
    SQL

    execute <<~SQL.squish
      UPDATE budgets
      SET month = date_trunc('month', month)::date
      WHERE month <> date_trunc('month', month)::date
    SQL
  end

  def down; end
end
