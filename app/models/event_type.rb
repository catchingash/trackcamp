class EventType < ActiveRecord::Base
  belongs_to :user
  # has_many :events # currently unused

  validates :user, presence: true # maintains referential integrity
  validates :name, presence: true
end
