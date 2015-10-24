class RenameGoogleIdToGoogleId < ActiveRecord::Migration
  def change
    rename_column :activity_types, :googleID, :google_id
  end
end
