class User < ActiveRecord::Base
  validates :uid, :email, presence: true
  validates :uid, :email, :refresh_token, uniqueness: true
end
