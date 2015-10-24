class Sleep < ActiveRecord::Base
  belongs_to :user

  validates :started_at, :ended_at, :user, presence: true # maintains referential integrity
  validates :started_at, :ended_at,
    numericality: {
      greater_than_or_equal_to: 1_262_304_000_000 # 1/1/2010
    }

  validates :rating,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 10
    },
    format: {
      with: /\A\d+(?:\.\d{0,2})?\z/ # limits it to a scale of 2 (x.xx)
    },
    allow_blank: true
end
