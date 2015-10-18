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

  describe 'DELETE #destroy' do
    before :each do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    it 'destroys the user from the db' do
      expect{ delete :destroy, id: @user.id }.to change { User.count }.by(-1)
    end

    it "destroys the user's associated activities" do
      2.times{ create(:activity, user: @user) }
      expect{ delete :destroy, id: @user.id }.to change { Activity.count }.by(-2)
    end

    it 'logs out the user' do
      delete :destroy, id: @user.id
      expect(session[:user_id]).to eq nil
    end

    it 'redirect_to root path' do
      delete :destroy, id: @user.id
      expect(response).to redirect_to root_path
    end
  end
end
