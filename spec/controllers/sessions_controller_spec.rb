require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let (:google_auth_hash) { {
    provider: 'google_oauth2',
    uid: '12345',
    info: {
      name: 'Firstname Lastname',
      email: 'lastname11@gmail.com',
      first_name: 'Firstname',
      last_name: 'Lastname',
      image: 'IAmAPhotoURL',
      urls: {
        google: 'https://plus.google.com/12345'
      }
    },
    credentials: {
      token: 'ya29.somethingsomethingsomething',
      expires_at:1444951206,
      expires:true
    },
    extra: {
      id_token: 'IAmAJSONWebToken',
      raw_info: {
        kind: 'plus#personOpenIdConnect',
        gender: 'IAmAGender',
        sub: '12345',
        name: 'Firstname Lastname',
        given_name: 'Firstname',
        family_name: 'Lastname',
        profile: 'https://plus.google.com/12345',
        picture: 'IAmAPhotoURL',
        email: 'lastname11@gmail.com',
        email_verified: 'true'
      }
    }
  } }

  describe 'GET create' do
    before { request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2] }

    context 'when user has no google fit data' do
      before :each do
        # doing this rather than maintaining a VCR because this isn't what the code is testing.
        allow(GoogleClient).to receive(:fit_segments) { false }
      end

      it 'does not require login' do
        session[:user_id] = nil
        get :create, provider: :google_oauth2

        expect(response).not_to redirect_to root_path
      end

      it 'only creates a new user record when appropriate' do
        expect{ get :create, provider: :google_oauth2 }.to change(User, :count).by(1) # first time, user is new
        session[:user_id] = nil
        expect{ get :create, provider: :google_oauth2 }.not_to change(User, :count) # second time, user is not new
      end

      context 'for new users' do
        let(:user) { User.last }

        before { get :create, provider: :google_oauth2 }
        after { user.destroy }

        it 'redirects to user dashboard' do
          expect(response).to redirect_to user_path(user.id)
        end

        it 'assigns user id to session[:user_id]' do
          expect(session[:user_id]).to eq user.id
        end

        it 'assigns user time zone to session[:time_zone]' do
          expect(session[:time_zone]).to eq user.time_zone
        end

        it 'assigns attributes correctly' do
          expect(user.uid).to eq google_auth_hash[:uid]
          expect(user.email).to eq google_auth_hash[:info][:email]
          expect(user.refresh_token).to eq google_auth_hash[:credentials][:token]
        end
      end

      context 'for existing users' do
        let(:user) { User.last }

        before do
          create(:user,
            uid: google_auth_hash[:uid],
            email: google_auth_hash[:info][:email],
            refresh_token: 'old.token'
          )
          get :create, provider: :google_oauth2
        end
        after { user.destroy }

        it 'redirects to user dashboard' do
          expect(response).to redirect_to user_path(user.id)
        end

        it 'assigns user id to session[:user_id]' do
          expect(session[:user_id]).to eq user.id
        end

        it 'updates the refresh token' do
          expect(user.refresh_token).to eq google_auth_hash[:credentials][:token]
        end
      end
    end

    pending 'when user has google fit data'
  end

  describe 'DELETE destroy' do
    before do
      user = create(:user)
      session[:user_id] = user.id
      delete :destroy
    end

    it 'sets session[:user_id] to nil' do
      expect(session[:user_id]).to be nil
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end
end
