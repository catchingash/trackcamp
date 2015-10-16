require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #show' do
    let(:user) { create(:user) }

    before :each do
      get :show, id: user.id
    end

    it 'renders the show template' do
      expect(response).to render_template :show
    end
  end
end
