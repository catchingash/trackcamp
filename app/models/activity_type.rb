class ActivityType < ActiveRecord::Base
  validates :name, presence: true
  validates :googleID, presence: true, uniqueness: true
end
