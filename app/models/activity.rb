require_relative '../../lib/google_client.rb'

class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity_type

  validates :start_time, :end_time, presence: true
  validates :activity_type, presence: true # maintains referential integrity
  validates :user, presence: true # maintains referential integrity

  def self.update_new(user_id, google_params)
    activities = GoogleClient.fit_segments(google_params)
    return unless activities

    activities.each do |activity_params|
      activity = Activity.new(activity_params)
      activity.user_id = user_id
      activity.save # TODO: implement error handling
    end
  end
end
