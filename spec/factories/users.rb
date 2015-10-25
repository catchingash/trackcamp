FactoryGirl.define do
  factory :user do
    sequence(:uid) { |n| "#{n}#{n}"}
    sequence(:email) { |n| "user#{n}#{n}@example.com" }
    # refresh_token # Note: refresh_token can be nil
    # time_zone # defaults to 'Pacific Time (US & Canada)'
  end
end
