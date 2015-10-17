FactoryGirl.define do
  factory :activity do
    start_time 1440000000
    end_time 1445000000
    activity_type
    user
    # data_source "MyString" # data_source can be null
  end
end
