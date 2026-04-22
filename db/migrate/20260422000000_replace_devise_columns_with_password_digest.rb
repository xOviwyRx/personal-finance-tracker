class ReplaceDeviseColumnsWithPasswordDigest < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :password_digest, :string

    remove_index :users, :reset_password_token
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at

    change_column_null :users, :password_digest, false
    change_column_default :users, :email, from: '', to: nil
  end

  def down
    change_column_default :users, :email, from: nil, to: ''
    change_column_null :users, :password_digest, true

    add_column :users, :remember_created_at, :datetime
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :reset_password_token, :string
    add_column :users, :encrypted_password, :string, default: '', null: false
    add_index :users, :reset_password_token, unique: true

    remove_column :users, :password_digest
  end
end
