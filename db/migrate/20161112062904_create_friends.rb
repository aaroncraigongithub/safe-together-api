class CreateFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :friends do |t|
      t.references :user, foreign_key: true
      t.references :friend, foreign_key: { to_table: :users }
      t.string     :invite_token
      t.datetime   :confirmed_at

      t.timestamps
    end

    add_index :friends, :invite_token, unique: true
  end
end
