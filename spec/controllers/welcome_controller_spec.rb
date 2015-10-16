require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  it 'does not require login' do
    session[:user_id] = nil
    get :index

    expect(flash[:error]).to be_nil
    expect(response).not_to redirect_to root_path
  end

  context 'when user is logged in' do
    it 'redirects to user dashboard' do
      user_id = 1
      session[:user_id] = user_id
      get :index
      expect(response).to redirect_to user_path(user_id)
    end
  end
end
