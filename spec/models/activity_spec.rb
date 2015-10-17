require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'model validations' do
    it 'creates a valid activity' do
      activity = build(:activity)
      expect(activity).to be_valid
    end

    describe 'presence validations' do
      it 'requires a start time' do
        activity = build(:activity, start_time: nil)
        expect(activity).to be_invalid
        expect(activity.errors).to include :start_time
      end

      it 'requires an end time' do
        activity = build(:activity, end_time: nil)
        expect(activity).to be_invalid
        expect(activity.errors).to include :end_time
      end

      it 'requires an activity type id' do
        activity = build(:activity, activity_type_id: nil)
        expect(activity).to be_invalid
        expect(activity.errors).to include :activity_type
      end

      it 'requires that the referenced activity type record exists' do
        activity = build(:activity, activity_type_id: 1)
        expect(activity).to be_invalid
        expect(activity.errors).to include :activity_type
      end

      it 'requires a user id' do
        activity = build(:activity, user_id: nil)
        expect(activity).to be_invalid
        expect(activity.errors).to include :user
      end

      it 'requires that the referenced user record exists' do
        activity = build(:activity, user_id: 1)
        expect(activity).to be_invalid
        expect(activity.errors).to include :user
      end
    end
  end
end
