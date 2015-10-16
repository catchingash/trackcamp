require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #show' do
    let(:user) { create(:user) }

    before :each do
      session[:user_id] = user.id
      get :show, id: user.id
    end

    context 'when user not logged in' do
      before :each do
        session[:user_id] = nil
        get :show, id: 1
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when user is not authorized' do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }

      before :each do
        session[:user_id] = user1.id

        get :show, id: user2.id
      end

      it "redirects to appropriate user's dashboard" do
        expect(response).to redirect_to user_path(user1.id)
      end
    end

    context 'when user is authorized' do
      let(:user) { create(:user) }
      before :each do
        session[:user_id] = user.id
        get :show, id: user.id
      end

      it 'renders the show template' do
        expect(response).to render_template :show
      end
    end
  end
end
