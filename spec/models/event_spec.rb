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
        expect(event.errors[:time]).to include "can't be blank"
      end

      it 'requires an event_type' do
        event = build(:event, event_type: nil)
        expect(event).to be_invalid
        expect(event.errors).to include :event_type
        expect(event.errors[:event_type]).to include "can't be blank"
      end

      it 'requires that the referenced event type record exists' do
        event = build(:event, event_type_id: 1)
        expect(event).to be_invalid
        expect(event.errors).to include :event_type
        expect(event.errors[:event_type]).to include "can't be blank"
      end

      it 'requires a user' do
        event = build(:event, user: nil)
        expect(event).to be_invalid
        expect(event.errors).to include :user
        expect(event.errors[:user]).to include "can't be blank"
      end

      it 'requires that the referenced user record exists' do
        event = build(:event, user_id: 1)
        expect(event).to be_invalid
        expect(event.errors).to include :user
        expect(event.errors[:user]).to include "can't be blank"
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
        expect(event.errors[:rating]).to include "is invalid"
      end

      it 'can be positive' do
        event = build(:event, rating: 100)
        expect(event).to be_valid
      end

      it 'can be negative' do
        event = build(:event, rating: -100)
        expect(event).to be_valid
      end
    end

    describe 'time validations' do
      it 'is invalid if less than 1262304000000' do
        event = build(:event, time: 1262303999999)
        expect(event).to be_invalid
        expect(event.errors).to include :time
        expect(event.errors[:time]).to include "must be greater than or equal to 1262304000000"
      end
    end
  end
end


