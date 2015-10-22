require 'rails_helper'

RSpec.describe EventTypesController, type: :controller do
  describe 'POST #create' do
    it 'requires login' do
      session[:user_id] = nil
      get :create

      expect(response).to redirect_to root_path
    end

    context 'when request is valid' do
      let(:create_params) { { event_type: attributes_for(:event_type)} }

      before :each do
        session[:user_id] = create(:user).id
        post :create, create_params
      end

      it 'returns a status code 201' do
        expect(response.status).to eq 201
      end

      it 'creates a new record' do
        expect(EventType.count).to eq 1
      end

      it 'returns json' do
        expect(response.content_type).to include 'application/json'
      end

      it 'returns the event type object' do
        obj = JSON.parse(response.body)
        expect(obj['user_id']).to eq session[:user_id]
        expect(obj.keys).to include 'id', 'user_id', 'name'
      end
    end

    context 'when request is invalid' do
      let(:invalid_params) { { event_type: attributes_for(:event_type, name: nil) } }

      before :each do
        session[:user_id] = create(:user).id
        post :create, invalid_params
      end

      it 'returns a status code 400' do
        expect(response.status).to eq 400
      end

      it 'does not create a new record' do
        expect(EventType.count).to eq 0
      end

      it 'returns json' do
        expect(response.content_type).to include 'application/json'
      end

      it 'returns the errors' do
        expect(response.body).to include 'name'
      end
    end
  end
end
