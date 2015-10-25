class AddColumnTimeZoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string, null: false, default: 'Pacific Time (US & Canada)'
  end
end
