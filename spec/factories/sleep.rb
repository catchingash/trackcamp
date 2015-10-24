FactoryGirl.define do
  factory :sleep do
    started_at 1_262_304_000_000 # this is the minimum set in the model
    ended_at 1_262_304_005_000
    # rating 1 # rating can be nil
    user
  end
end
