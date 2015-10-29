require_relative '../../lib/date_helpers'

class User < ActiveRecord::Base
  has_many :activities, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :event_types, dependent: :destroy
  has_many :sleep, dependent: :destroy

  validates :uid, :email, presence: true, uniqueness: true

  def update_all
    Activity.update_new(id, google_fit_params)
    Event.update_weight(id, google_weight_params)
  end

  # for use in the API response
  def activities_by_date
    activities.includes(:activity_type).order(:started_at).map do |activity|
      {
        started_at: activity.started_at,
        ended_at: activity.ended_at,
        activity_type: activity.activity_type.name,
        data_source: activity.data_source
      }
    end
  end

  # for use in the API response
  def events_by_type(event_type)
    event_type = EventType.find_by(name: event_type)
    return unless event_type

    events.order(:time).where(event_type_id: event_type.id).map do |event|
      {
        time: event.time,
        rating: event.rating,
        note: event.note,
        event_type: event_type.name
      }
    end
  end

  private

  def google_fit_params
    {
      refresh_token: refresh_token,
      started_at: last_activity_date || '000000000000000000'
    }
  end

  def google_weight_params
    {
      refresh_token: refresh_token
    }
  end

  def last_activity_date
    activities.maximum('started_at')
  end
end
