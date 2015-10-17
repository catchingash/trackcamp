require 'rails_helper'

RSpec.describe ActivityType, type: :model do
  describe 'model validations' do
    it 'creates a valid activity_type' do
      activity_type = build(:activity_type)
      expect(activity_type).to be_valid
    end

    describe 'presence validations' do
      it 'requires a uid' do
        activity_type = build(:activity_type, name: nil)
        expect(activity_type).to be_invalid
        expect(activity_type.errors).to include :name
      end

      it 'requires a googleID' do
        activity_type = build(:activity_type, googleID: nil)
        expect(activity_type).to be_invalid
        expect(activity_type.errors).to include :googleID
      end
    end

    describe 'uniqueness validations' do
      it 'requires a unique googleID' do
        create(:activity_type, googleID: 1)
        activity_type = build(:activity_type, googleID: 1)
        expect(activity_type).to be_invalid
        expect(activity_type.errors).to include :googleID
      end
    end
  end
end
