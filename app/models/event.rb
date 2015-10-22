class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_type

  validates :time, :event_type, :user, presence: true # maintains referential integrity
  validates :time, numericality: {
    greater_than_or_equal_to: 1262304000000 # 1/1/2010
  }
  validates :rating, numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 10
    },
    format: {
      with: /\A\d+(?:\.\d{0,2})?\z/ # limits it to a scale of 2 (.xx)
    },
    allow_blank: true
end
