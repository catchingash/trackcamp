class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
      t.integer :user_id, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
    add_foreign_key :event_types, :users
  end
end
