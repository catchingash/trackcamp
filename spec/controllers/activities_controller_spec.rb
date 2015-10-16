require 'rails_helper'

RSpec.describe ActivitiesController, type: :controller do
  context 'when user not logged in' do
    before :each do
      session[:user_id] = nil
      get :index
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end
end
