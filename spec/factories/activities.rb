FactoryGirl.define do
  factory :activity do
    start_time 1_440_000_000
    end_time 1_445_000_000
    activity_type
    user
    # data_source 'MyString' # data_source can be null
  end
end
