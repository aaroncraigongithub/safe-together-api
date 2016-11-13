class CreateAlerts < ActiveRecord::Migration[5.0]
  def change
    create_table :alerts do |t|
      t.references :user, foreign_key: true
      t.integer :level, default: 0
      t.datetime :deactivated_at
      t.string   :uuid

      t.timestamps
    end

    add_index :alerts, :uuid, unique: true
  end
end
