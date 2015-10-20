class User < ActiveRecord::Base
  has_many :activities, dependent: :destroy

  validates :uid, :email, presence: true, uniqueness: true

  def update_all
    Activity.update_new(self.id, google_params)
  end

  def activities_by_date
    self.activities.order(:start_time)
  end

  private

  def google_params
    { refresh_token: self.refresh_token,
      start_time: last_activity_date || (Time.now.beginning_of_day.to_r * 1000).round - 2678000000 # defaults to 31 days ago
    }
  end

  def last_activity_date
    self.activities.maximum('start_time')
  end

end
