FactoryGirl.define do
  factory :event do
    time 1_262_304_000_000 # this is the minimum set in the model
    # rating 1.5 # rating is not required
    # note 'MyText' # note is not required
    event_type
    user
  end
end
