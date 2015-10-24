FactoryGirl.define do
  factory :activity do
    started_at 1_440_000_000
    ended_at 1_445_000_000
    activity_type
    user
    # data_source 'MyString' # data_source can be null
  end
end
