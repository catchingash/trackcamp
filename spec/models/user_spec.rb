require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'model validations' do
    it 'creates a valid user' do
      user = build(:user)
      expect(user).to be_valid
    end

    it "defaults time zone to 'Pacific Time (US & Canada)'" do
      user = build(:user)
      expect(user.time_zone).to eq 'Pacific Time (US & Canada)'
    end

    describe 'presence validations' do
      it 'requires a uid' do
        user = build(:user, uid: nil)
        expect(user).to be_invalid
        expect(user.errors).to include :uid
        expect(user.errors[:uid]).to include "can't be blank"
      end

      it 'requires an email' do
        user = build(:user, email: nil)
        expect(user).to be_invalid
        expect(user.errors).to include :email
        expect(user.errors[:email]).to include "can't be blank"
      end
    end

    describe 'uniqueness validations' do
      it 'requires a unique uid' do
        create(:user, uid: '1234')
        user = build(:user, uid: '1234')
        expect(user).to be_invalid
        expect(user.errors).to include :uid
        expect(user.errors[:uid]).to include "has already been taken"
      end

      it 'requires a unique email' do
        create(:user, email: 'email@example.com')
        user = build(:user, email: 'email@example.com')
        expect(user).to be_invalid
        expect(user.errors).to include :email
        expect(user.errors[:email]).to include "has already been taken"
      end
    end
  end

  describe '#destroy' do
    let(:user) { create(:user) }
    let(:num_dependent) { 2 }

    it 'destroys all associated activities records' do
      num_dependent.times { create(:activity, user: user) }
      expect{ user.destroy }.to change{ Activity.count }.by(-num_dependent)
    end

    it 'destroys all associated event records' do
      num_dependent.times { create(:event, user: user) }
      expect{ user.destroy }.to change{ Event.count }.by(-num_dependent)
    end

    it 'destroys all associated event type records' do
      num_dependent.times { create(:event_type, user: user) }
      expect{ user.destroy }.to change{ EventType.count }.by(-num_dependent)
    end

    it 'destroys all associated sleep records' do
      num_dependent.times { create(:sleep, user: user) }
      expect{ user.destroy }.to change{ Sleep.count }.by(-num_dependent)
    end
  end

  describe '#update_all' do
    it 'fetches all new Google Fit activities'
  end

  describe '#activities_by_date' do
    it 'returns an array of hashes'
    it 'returns started_at, ended_at, activity_type, and data_source for each activity'
    it "returns all of a user's activities, ordered by started_at"
  end
end
