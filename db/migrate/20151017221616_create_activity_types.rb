class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.string :name, null: false
      t.integer :googleID, null: false

      t.timestamps null: false
    end
    add_index :activity_types, :googleID, unique: true
  end
end
