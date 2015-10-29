require_relative '../../lib/date_helpers'

class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_type

  validates :time, :event_type, :user, presence: true # maintains referential integrity
  validates :time, numericality: {
    greater_than_or_equal_to: 1_262_304_000_000 # 1/1/2010
  }
  validates :rating,
    numericality: true,
    format: {
      with: /\A-?\d+(?:\.\d{0,2})?\z/ # limits it to a scale of 2 (x.xx)
    },
    allow_blank: true

  def self.update_weight(user_id, google_params)
    event_type = EventType.find_or_create_by(user_id: user_id, name: 'Weight')

    google_params[:started_at] = last_weight_date(user_id, event_type.id)
    weights = GoogleClient.fetch_weights(google_params)
    return unless weights

    weights.each do |weight_params|
      weight = Event.new(weight_params)
      weight.user_id = user_id
      weight.event_type_id = event_type.id
      weight.save # TODO: implement error handling
    end
  end

  private

  def self.last_weight_date(user_id, event_type_id)
    Event.where(user_id: user_id, event_type_id: event_type_id)
      .maximum('time') || '000000000000000000'
  end
end
