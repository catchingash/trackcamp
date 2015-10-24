require 'rails_helper'

RSpec.describe ActivitiesController, type: :controller do
  describe 'GET index' do
    context 'when user not logged in' do
      before :each do
        session[:user_id] = nil
        get :index
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    it 'returns json'
    it 'returns an array of hashes'
    it 'returns started_at, ended_at, activity_type, and data_source for each activity'
    it "returns all of a user's activities, ordered by started_at"
  end
end
