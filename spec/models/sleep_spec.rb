require 'rails_helper'

RSpec.describe Sleep, type: :model do
  describe 'model validations' do
    it 'creates a valid sleep' do
      sleep = build(:sleep)
      expect(sleep).to be_valid
    end

    describe 'presence validations' do
      it 'requires started_at' do
        sleep = build(:sleep, started_at: nil)
        expect(sleep).to be_invalid
        expect(sleep.errors).to include :started_at
        expect(sleep.errors[:started_at]).to include "can't be blank"
      end

      it 'requires an ended_at' do
        sleep = build(:sleep, ended_at: nil)
        expect(sleep).to be_invalid
        expect(sleep.errors).to include :ended_at
        expect(sleep.errors[:ended_at]).to include "can't be blank"
      end

      it 'requires a user' do
        sleep = build(:sleep, user: nil)
        expect(sleep).to be_invalid
        expect(sleep.errors).to include :user
        expect(sleep.errors[:user]).to include "can't be blank"
      end

      it 'requires that the referenced user record exists' do
        sleep = build(:sleep, user_id: 1)
        expect(sleep).to be_invalid
        expect(sleep.errors).to include :user
        expect(sleep.errors[:user]).to include "can't be blank"
      end
    end

    describe 'rating validations' do
      it 'can be empty' do
        sleep = build(:sleep, rating: nil)
        expect(sleep).to be_valid
      end

      it 'must have <= 2 decimals (1.11 is valid)' do
        sleep = build(:sleep, rating: 1.11)
        expect(sleep).to be_valid
      end

      it 'must have <= 2 decimals (1.111 is invalid)' do
        sleep = build(:sleep, rating: 1.111)
        expect(sleep).to be_invalid
        expect(sleep.errors).to include :rating
        expect(sleep.errors[:rating]).to include "is invalid"
      end

      it 'must be betweeen 0 and 10 (0 is valid)' do
        sleep = build(:sleep, rating: 0)
        expect(sleep).to be_valid
      end

      it 'must be betweeen 0 and 10 (10 is valid)' do
        sleep = build(:sleep, rating: 10)
        expect(sleep).to be_valid
      end

      it 'must be betweeen 0 and 10 (-1 is invalid)' do
        sleep = build(:sleep, rating: -1)
        expect(sleep).to be_invalid
        expect(sleep.errors).to include :rating
        expect(sleep.errors[:rating]).to include "must be greater than or equal to 0"
      end

      it 'must be betweeen 0 and 10 (10.1 is invalid)' do
        sleep = build(:sleep, rating: 10.1)
        expect(sleep).to be_invalid
        expect(sleep.errors).to include :rating
        expect(sleep.errors[:rating]).to include "must be less than or equal to 10"
      end
    end

    describe 'time validations' do
      it 'is invalid if started_at is less than 1262304000000' do
        sleep = build(:sleep, started_at: 1262303999999)
      end

      it 'is invalid if ended_at is less than 1262304000000' do
        sleep = build(:sleep, ended_at: 1262303999999)
      end
    end
  end
end
