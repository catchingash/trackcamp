require 'rails_helper'

RSpec.describe EventType, type: :model do
  describe 'model validations' do
    it 'creates a valid event_type' do
      event_type = build(:event_type)
      expect(event_type).to be_valid
    end

    describe 'presence validations' do
      it 'requires a name' do
        event_type = build(:event_type, name: nil)
        expect(event_type).to be_invalid
        expect(event_type.errors).to include :name
        expect(event_type.errors[:name]).to include "can't be blank"
      end

      it 'requires a user' do
        event_type = build(:event_type, user: nil)
        expect(event_type).to be_invalid
        expect(event_type.errors).to include :user
        expect(event_type.errors[:user]).to include "can't be blank"
      end

      it 'requires that the referenced user record exists' do
        event_type = build(:event_type, user_id: 1)
        expect(event_type).to be_invalid
        expect(event_type.errors).to include :user
        expect(event_type.errors[:user]).to include "can't be blank"
      end
    end
  end
end

