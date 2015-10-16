require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let (:google_auth_hash) { {
    provider: "google_oauth2",
    uid: "12345",
    info: {
      name: "Firstname Lastname",
      email: "lastname11@gmail.com",
      first_name: "Firstname",
      last_name: "Lastname",
      image: "IAmAPhotoURL",
      urls: {
        google: "https://plus.google.com/12345"
      }
    },
    credentials: {
      token: "ya29.somethingsomethingsomething",
      expires_at:1444951206,
      expires:true
    },
    extra: {
      id_token: "IAmAJSONWebToken",
      raw_info: {
        kind: "plus#personOpenIdConnect",
        gender: "IAmAGender",
        sub: "12345",
        name: "Firstname Lastname",
        given_name: "Firstname",
        family_name: "Lastname",
        profile: "https://plus.google.com/12345",
        picture: "IAmAPhotoURL",
        email: "lastname11@gmail.com",
        email_verified: "true"
      }
    }
  } }

  describe 'GET create' do
    before { request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2] }

    context 'for new users' do
      it 'redirects to root path' do
        get :create, provider: :google_oauth2
        expect(response).to redirect_to(root_path)
      end

      it 'creates a new user' do
        expect{ get :create, provider: :google_oauth2 }.to change(User, :count).by(1)
      end

      it 'assigns user id to session[:user_id]' do
        get :create, provider: :google_oauth2
        id = User.maximum('id')
        expect(session[:user_id]).to eq(id)
      end

      it 'sets flash[:message]' do
        get :create, provider: :google_oauth2
        expect(flash[:message]).not_to be nil
        expect(flash[:message]).to include :success
      end
    end

    context 'for existing users' do
      before :each do
        create(:user, uid: google_auth_hash[:uid], email: google_auth_hash[:info][:email])
      end

      it 'redirects to root path' do
        get :create, provider: :google_oauth2
        expect(response).to redirect_to(root_path)
      end

      it 'does not create a new user' do
        expect{ get :create, provider: :google_oauth2 }.not_to change(User, :count)
      end

      it 'assigns user id to session[:user_id]' do
        get :create, provider: :google_oauth2
        id = User.maximum('id')
        expect(session[:user_id]).to eq(id)
      end

      it 'sets flash[:message]' do
        get :create, provider: :google_oauth2
        expect(flash[:message]).not_to be nil
        expect(flash[:message]).to include :success
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      user = create(:user)
      session[:user_id] = user.id
      delete :destroy
    end

    it 'sets flash[:message]' do
      expect(flash[:message]).not_to be nil
      expect(flash[:message]).to include :success
    end

    it 'sets session[:user_id] to nil' do
      expect(session[:user_id]).to be nil
    end

    it 'redirects to root path' do
      expect(response).to redirect_to(root_path)
    end

  end
end
