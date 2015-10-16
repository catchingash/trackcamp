class User < ActiveRecord::Base
  validates :uid, :email, presence: true, uniqueness: true
end
