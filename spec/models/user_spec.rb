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
        expect(user.errors).to include(:uid)
      end

      it 'requires an email' do
        user = build(:user, email: nil)
        expect(user).to be_invalid
        expect(user.errors).to include(:email)
      end
    end

    describe 'uniqueness validations' do
      it 'requires a unique uid' do
        create(:user, uid: '1234')
        user = build(:user, uid: '1234')
        expect(user).to be_invalid
        expect(user.errors).to include(:uid)
      end

      it 'requires a unique email' do
        create(:user, email: 'email@example.com')
        user = build(:user, email: 'email@example.com')
        expect(user).to be_invalid
        expect(user.errors).to include(:email)
      end

      it 'requires a unique refresh token' do
        create(:user, refresh_token: 'repeat')
        user = build(:user, refresh_token: 'repeat')
        expect(user).to be_invalid
        expect(user.errors).to include(:refresh_token)
      end
    end
  end
end
