require 'rails_helper'

RSpec.describe ActivityType, type: :model do
  describe 'model validations' do
    it 'creates a valid activity_type' do
      activity_type = build(:activity_type)
      expect(activity_type).to be_valid
    end

    describe 'presence validations' do
      it 'requires a name' do
        activity_type = build(:activity_type, name: nil)
        expect(activity_type).to be_invalid
        expect(activity_type.errors).to include :name
        expect(activity_type.errors[:name]).to include "can't be blank"
      end

      it 'requires a google id' do
        activity_type = build(:activity_type, google_id: nil)
        expect(activity_type).to be_invalid
        expect(activity_type.errors).to include :google_id
        expect(activity_type.errors[:google_id]).to include "can't be blank"
      end
    end

    describe 'uniqueness validations' do
      it 'requires a unique google id' do
        create(:activity_type, google_id: 1)
        activity_type = build(:activity_type, google_id: 1)
        expect(activity_type).to be_invalid
        expect(activity_type.errors).to include :google_id
        expect(activity_type.errors[:google_id]).to include "has already been taken"
      end
    end
  end
end
