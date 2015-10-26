require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:event_type) { create(:event_type, user_id: user.id) }
  let(:time_string) { '2015-01-31T15:30' }

  describe 'POST #create' do
    it 'requires login' do
      session[:user_id] = nil
      post :create

      expect(response).to redirect_to root_path
    end

    context 'when request is valid' do
      let(:create_params) { { event: attributes_for(:event, time: time_string, event_type_id: event_type.id)} }

      before :each do
        session[:user_id] = user.id
        post :create, create_params
      end

      # it 'returns a status code 201' do
      #   expect(response.status).to eq 201
      # end

      it 'creates a new record' do
        expect(Event.count).to eq 1
      end

      # it 'returns json' do
      #   expect(response.content_type).to include 'application/json'
      # end

      # it 'returns the event type object' do
      #   obj = JSON.parse(response.body)
      #   expect(obj['user_id']).to eq session[:user_id]
      #   expect(obj.keys).to include 'id', 'time', 'rating', 'note', 'event_type_id', 'user_id'
      # end
    end

    context 'when request is invalid' do
      let(:invalid_params) { { event: attributes_for(:event, time: time_string, event_type_id: nil) } }

      before :each do
        session[:user_id] = user.id
        post :create, invalid_params
      end

      # it 'returns a status code 400' do
      #   expect(response.status).to eq 400
      # end

      it 'does not create a new record' do
        expect(Event.count).to eq 0
      end

      # it 'returns json' do
      #   expect(response.content_type).to include 'application/json'
      # end

      # it 'returns the errors' do
      #   expect(response.body).to include 'event_type', "can't be blank"
      # end
    end
  end

  describe 'PATCH #update' do
    let(:old_note) { 'old note' }
    let(:event) { create(:event, note: old_note, user_id: user.id, event_type_id: event_type.id) }

    context 'when request is valid' do
      let(:updated_note) { 'new note' }
      let(:update_params) { { note: updated_note } }

      before :each do
        session[:user_id] = user.id
        patch :update, id: event.id, event: update_params
        event.reload
      end

      it 'returns status code 200' do
        expect(response.status).to eq 200
      end

      it 'updates the record' do
        expect(event.note).to eq updated_note
      end

      it 'returns json' do
        expect(response.content_type).to include 'application/json'
      end

      it 'returns the updated record' do
        obj = JSON.parse(response.body)
        expect(obj['id']).to eq event.id
        expect(obj['note']).to eq event.note
        expect(obj.keys).to include 'id', 'time', 'rating', 'note', 'event_type_id', 'user_id'
      end
    end

    context 'when request is invalid' do
      let(:invalid_params) { attributes_for(:event, time: time_string, note: old_note, event_type_id: nil)  }

      before :each do
        session[:user_id] = user.id
        patch :update, id: event.id, event: invalid_params
        event.reload
      end

      it 'returns status code 400' do
        expect(response.status).to eq 400
      end

      it 'does not update the record' do
        expect(event.note).to eq old_note
      end

      it 'returns json' do
        expect(response.content_type).to include 'application/json'
      end

      it 'returns the errors' do
        expect(response.body).to include 'event_type', "can't be blank"
      end
    end

    context 'when user is not authorized' do
      let(:update_params) { { event: attributes_for(:event, time: time_string, note: 'new note') } }

      before :each do
        session[:user_id] = create(:user).id
        patch :update, id: event.id, event: update_params
        event.reload
      end

      it 'returns status code 404' do
        expect(response.status).to eq 404
      end

      it 'does not update the record' do
        expect(event.note).to eq old_note
      end

      it 'returns json' do
        expect(response.content_type).to include 'application/json'
      end

      it 'returns an empty body' do
        expect(response.body).to eq 'null'
      end
    end
  end
end
