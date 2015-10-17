require_relative '../../lib/google_client.rb'

class User < ActiveRecord::Base
  validates :uid, :email, presence: true, uniqueness: true

  def fetch_activity_sessions
    GoogleClient.fit_sessions(self.refresh_token)
  end
end
