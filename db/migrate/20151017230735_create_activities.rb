class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.column :start_time, :bigint, null: false
      t.column :end_time, :bigint, null: false
      t.integer :activity_type_id, null: false, index: true
      t.integer :user_id, null: false, index: true
      t.string :data_source

      t.timestamps null: false
    end
    add_foreign_key :activities, :activity_types
    add_foreign_key :activities, :users
  end
end
