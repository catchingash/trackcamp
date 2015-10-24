class CreateSleep < ActiveRecord::Migration
  def change
    create_table :sleep do |t|
      t.column :started_at, :bigint, null: false
      t.column :ended_at, :bigint, null: false
      t.float :rating, scale: 2
      t.integer :user_id, null: false, index: true

      t.timestamps null: false
    end
    add_foreign_key :sleep, :users
  end
end
