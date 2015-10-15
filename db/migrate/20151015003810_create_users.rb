class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid, null: false
      t.string :email, null: false
      t.string :refresh_token

      t.timestamps null: false
    end
    add_index :users, :uid, unique: true
    add_index :users, :email, unique: true
    add_index :users, :refresh_token, unique: true
  end
end
