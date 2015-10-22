require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'model validations' do
    it 'creates a valid user' do
      user = build(:user)
      expect(user).to be_valid
    end

    describe 'presence validations' do
      it 'requires a uid' do
        user = build(:user, uid: nil)
        expect(user).to be_invalid
        expect(user.errors).to include :uid
      end

      it 'requires an email' do
        user = build(:user, email: nil)
        expect(user).to be_invalid
        expect(user.errors).to include :email
      end
    end

    describe 'uniqueness validations' do
      it 'requires a unique uid' do
        create(:user, uid: '1234')
        user = build(:user, uid: '1234')
        expect(user).to be_invalid
        expect(user.errors).to include :uid
      end

      it 'requires a unique email' do
        create(:user, email: 'email@example.com')
        user = build(:user, email: 'email@example.com')
        expect(user).to be_invalid
        expect(user.errors).to include :email
      end
    end
  end

  describe '#destroy' do
    it 'destroys all associated activities records' do
      user = create(:user)
      num_activities = 2
      num_activities.times { create(:activity, user: user) }

      expect{ user.destroy }.to change{ Activity.count }.by(-num_activities)
    end

    it 'destroys all associated event records' do
      user = create(:user)
      num_events = 2
      num_events.times { create(:event, user: user) }

      expect{ user.destroy }.to change{ Event.count }.by(-num_events)
    end

    it 'destroys all associated event type records' do
      user = create(:user)
      num_event_types = 2
      num_event_types.times { create(:event_type, user: user) }

      expect{ user.destroy }.to change{ EventType.count }.by(-num_event_types)
    end
  end

  describe '#update_all' do
    it 'fetches all new Google Fit activities'
  end

  describe '#activities_by_date' do
    it 'returns an array of hashes'
    it 'returns start_time, end_time, activity_type, and data_source for each activity'
    it "returns all of a user's activities, ordered by start_time"
  end
end
