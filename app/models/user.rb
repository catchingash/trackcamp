class User < ActiveRecord::Base
  has_many :activities, dependent: :destroy

  validates :uid, :email, presence: true, uniqueness: true

  def update_and_return_activities
    Activity.fetch_segments(self.id, self.refresh_token)
    return self.activities
  end

end
