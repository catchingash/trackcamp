require_relative '../../lib/google_client.rb'

class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity_type

  validates :start_time, :end_time, presence: true
  validates :activity_type, presence: true # maintains referential integrity
  validates :user, presence: true # maintains referential integrity

  def self.fetch_segments(user_id, refresh_token)
    activities = GoogleClient.fit_segments(refresh_token)
    # return nil if activities.error
    activities.each do |activity_params|
      activity = Activity.new(activity_params)
      activity.user_id = user_id
      activity.save # TODO: implement error handling
    end
  end
end
