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
      end

      it 'requires a user' do
        event_type = build(:event_type, user: nil)
        expect(event_type).to be_invalid
        expect(event_type.errors).to include :user
      end

      it 'requires that the referenced user record exists' do
        event = build(:event, user_id: 1)
        expect(event).to be_invalid
        expect(event.errors).to include :user
      end
    end
  end
end

