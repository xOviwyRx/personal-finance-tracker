# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_05_28_161211) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budgets", force: :cascade do |t|
    t.decimal "monthly_limit", precision: 12, scale: 2, null: false
    t.date "month", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "alerted_status", default: 0, null: false
    t.index ["category_id"], name: "index_budgets_on_category_id"
    t.index ["user_id", "category_id", "month"], name: "index_budgets_on_user_id_and_category_id_and_month", unique: true
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "recurring_transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.string "title", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.string "transaction_type", null: false
    t.date "start_on", null: false
    t.date "next_run_on", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_recurring_transactions_on_category_id"
    t.index ["next_run_on"], name: "index_recurring_transactions_on_next_run_on"
    t.index ["user_id"], name: "index_recurring_transactions_on_user_id"
    t.check_constraint "amount > 0::numeric", name: "recurring_transactions_amount_positive"
    t.check_constraint "transaction_type::text = ANY (ARRAY['income'::character varying, 'expense'::character varying]::text[])", name: "recurring_transactions_type_check"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "title", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.date "date", null: false
    t.string "transaction_type", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "recurring_transaction_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["recurring_transaction_id", "date"], name: "index_transactions_on_recurring_rule_and_date", unique: true, where: "(recurring_transaction_id IS NOT NULL)"
    t.index ["user_id", "category_id", "date", "transaction_type"], name: "index_transactions_on_user_category_date_and_type"
    t.index ["user_id"], name: "index_transactions_on_user_id"
    t.check_constraint "amount > 0::numeric", name: "transactions_amount_positive"
    t.check_constraint "transaction_type::text = ANY (ARRAY['income'::character varying, 'expense'::character varying]::text[])", name: "transactions_type_check"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "budgets", "categories"
  add_foreign_key "budgets", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "recurring_transactions", "categories"
  add_foreign_key "recurring_transactions", "users"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "recurring_transactions", on_delete: :nullify
  add_foreign_key "transactions", "users"
end
