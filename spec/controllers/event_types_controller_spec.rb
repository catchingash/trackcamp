require 'rails_helper'

RSpec.describe EventTypesController, type: :controller do
  describe 'POST #create' do
    it 'requires login' do
      session[:user_id] = nil
      post :create

      expect(response).to redirect_to root_path
    end

    context 'when request is valid' do
      let(:create_params) { { event_type: attributes_for(:event_type)} }

      before :each do
        session[:user_id] = create(:user).id
        post :create, create_params
      end

      # it 'returns a status code 201' do
      #   expect(response.status).to eq 201
      # end

      it 'creates a new record' do
        expect(EventType.count).to eq 1
      end

      # it 'returns json' do
      #   expect(response.content_type).to include 'application/json'
      # end

      # it 'returns the event type object' do
      #   obj = JSON.parse(response.body)
      #   expect(obj['user_id']).to eq session[:user_id]
      #   expect(obj.keys).to include 'id', 'user_id', 'name'
      # end
    end

    context 'when request is invalid' do
      let(:invalid_params) { { event_type: attributes_for(:event_type, name: nil) } }

      before :each do
        session[:user_id] = create(:user).id
        post :create, invalid_params
      end

      # it 'returns a status code 400' do
      #   expect(response.status).to eq 400
      # end

      it 'does not create a new record' do
        expect(EventType.count).to eq 0
      end

      # it 'returns json' do
      #   expect(response.content_type).to include 'application/json'
      # end

      # it 'returns the errors' do
      #   expect(response.body).to include 'name'
      # end
    end
  end

  # describe 'PATCH #update' do
  #   let(:user) { create(:user) }
  #   let(:old_name) { 'old name' }
  #   let(:event_type) { create(:event_type, name: old_name, user_id: user.id) }

  #   context 'when request is valid' do
  #     let(:updated_name) { 'new_name' }
  #     let(:update_params) { attributes_for(:event_type, name: updated_name) }

  #     before :each do
  #       session[:user_id] = user.id
  #       patch :update, id: event_type.id, event_type: update_params
  #       event_type.reload
  #     end

  #     it 'returns status code 200' do
  #       expect(response.status).to eq 200
  #     end

  #     it 'updates the record' do
  #       expect(event_type.name).to eq updated_name
  #     end

  #     it 'returns json' do
  #       expect(response.content_type).to include 'application/json'
  #     end

  #     it 'returns the updated record' do
  #       obj = JSON.parse(response.body)
  #       expect(obj['id']).to eq event_type.id
  #       expect(obj.keys).to include 'id', 'user_id', 'name'
  #     end
  #   end

  #   context 'when request is invalid' do
  #     let(:invalid_params) { attributes_for(:event_type, name: nil)  }

  #     before :each do
  #       session[:user_id] = user.id
  #       patch :update, id: event_type.id, event_type: invalid_params
  #       event_type.reload
  #     end

  #     it 'returns status code 400' do
  #       expect(response.status).to eq 400
  #     end

  #     it 'does not update the record' do
  #       expect(event_type.name).to eq old_name
  #     end

  #     it 'returns json' do
  #       expect(response.content_type).to include 'application/json'
  #     end

  #     it 'returns the errors' do
  #       expect(response.body).to include 'name', "can't be blank"
  #     end
  #   end

  #   context 'when user is not authorized' do
  #     let(:update_params) { { event_type: attributes_for(:event_type, name: 'updated name') } }

  #     before :each do
  #       session[:user_id] = create(:user).id
  #       patch :update, id: event_type.id, event_type: update_params
  #       event_type.reload
  #     end

  #     it 'returns status code 404' do
  #       expect(response.status).to eq 404
  #     end

  #     it 'does not update the record' do
  #       expect(event_type.name).to eq old_name
  #     end

  #     it 'returns json' do
  #       expect(response.content_type).to include 'application/json'
  #     end

  #     it 'returns an empty body' do
  #       expect(response.body).to eq 'null'
  #     end
  #   end
  # end
end
