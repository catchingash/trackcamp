class ActivityType < ActiveRecord::Base
  # has_many :activities # TODO: remove if remains unused

  validates :name, presence: true
  validates :google_id, presence: true, uniqueness: true
end
