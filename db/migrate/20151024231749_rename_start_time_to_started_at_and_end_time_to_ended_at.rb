class RenameStartTimeToStartedAtAndEndTimeToEndedAt < ActiveRecord::Migration
  def change
    rename_column :activities, :start_time, :started_at
    rename_column :activities, :end_time, :ended_at
  end
end
