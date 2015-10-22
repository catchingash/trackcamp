require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'model validations' do
    it 'creates a valid event' do
      event = build(:event)
      expect(event).to be_valid
    end

    describe 'presence validations' do
      it 'requires a time' do
        event = build(:event, time: nil)
        expect(event).to be_invalid
        expect(event.errors).to include :time
      end

      it 'requires an event_type' do
        event = build(:event, event_type: nil)
        expect(event).to be_invalid
        expect(event.errors).to include :event_type
      end

      it 'requires that the referenced event type record exists' do
        event = build(:event, event_type_id: 1)
        expect(event).to be_invalid
        expect(event.errors).to include :event_type
      end

      it 'requires a user' do
        event = build(:event, user: nil)
        expect(event).to be_invalid
        expect(event.errors).to include :user
      end

      it 'requires that the referenced user record exists' do
        event = build(:event, user_id: 1)
        expect(event).to be_invalid
        expect(event.errors).to include :user
      end
    end

    describe 'rating validations' do
      it 'can be empty' do
        event = build(:event, rating: nil)
        expect(event).to be_valid
      end

      it 'must have <= 2 decimals (1.11 is valid)' do
        event = build(:event, rating: 1.11)
        expect(event).to be_valid
      end

      it 'must have <= 2 decimals (1.111 is invalid)' do
        event = build(:event, rating: 1.111)
        expect(event).to be_invalid
        expect(event.errors).to include :rating
      end

      it 'must be betweeen 0 and 10 (0 is valid)' do
        event = build(:event, rating: 0)
        expect(event).to be_valid
      end

      it 'must be betweeen 0 and 10 (10 is valid)' do
        event = build(:event, rating: 10)
        expect(event).to be_valid
      end

      it 'must be betweeen 0 and 10 (-1 is invalid)' do
        event = build(:event, rating: -1)
        expect(event).to be_invalid
        expect(event.errors).to include :rating
      end

      it 'must be betweeen 0 and 10 (10.1 is invalid)' do
        event = build(:event, rating: 10.1)
        expect(event).to be_invalid
        expect(event.errors).to include :rating
      end
    end

    describe 'time validations' do
      it 'is invalid if less than 1262304000000' do
        event = build(:event, time: 1262303999999)
      end
    end
  end
end


