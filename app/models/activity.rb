class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity_type

  validates :start_time, :end_time, presence: true
  validates :activity_type, presence: true # this also maintains referential integrity
  validates :user, presence: true # maintains referential integrity
end
