class ActivitiesController < ApplicationController
  def index
    user = User.find(session[:user_id])
    render json: user.fetch_activity_segments
  end
end
