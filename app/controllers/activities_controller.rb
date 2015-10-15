require_relative '../../lib/google_client.rb'

class ActivitiesController < ApplicationController
  def index
    render json: GoogleClient.fit_sessions
  end
end
