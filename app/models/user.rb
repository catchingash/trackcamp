class User < ActiveRecord::Base
  has_many :activities, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :event_types, dependent: :destroy
  has_many :sleep, dependent: :destroy

  validates :uid, :email, presence: true, uniqueness: true

  def update_all
    Activity.update_new(id, google_params)
  end

  # for use in the API response
  def activities_by_date
    results = []
    activities.includes(:activity_type).order(:started_at).each do |activity|
      a = {}
      a[:started_at] = activity.started_at
      a[:ended_at] = activity.ended_at
      a[:activity_type] = activity.activity_type.name
      a[:data_source] = activity.data_source
      results << a
    end
    results
  end

  private

  def google_params
    { refresh_token: refresh_token,
      started_at: last_activity_date ||
        # defaults to 31 days ago
        (Time.current.beginning_of_day.to_r * 1_000).round - 2_678_000_000
    }
  end

  def last_activity_date
    activities.maximum('started_at')
  end
end
