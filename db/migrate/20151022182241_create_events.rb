class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column :time, :bigint, null: false
      t.float :rating, scale: 2
      t.text :note
      t.integer :event_type_id, null: false, index: true
      t.integer :user_id, null: false, index: true

      t.timestamps null: false
    end
    add_foreign_key :events, :event_types
    add_foreign_key :events, :users
  end
end
