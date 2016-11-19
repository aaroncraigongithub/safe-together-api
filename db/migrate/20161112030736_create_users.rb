class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :confirmed_at
      t.string :confirm_token
      t.string :token
      t.string :uuid

      t.timestamps
    end

    add_index :users, :token, unique: true
    add_index :users, :uuid, unique: true
    add_index :users, :confirm_token, unique: true
    execute "CREATE UNIQUE INDEX index_users_on_lowercase_email
             ON users USING btree (lower(email));"
    end
end
