class ActivitiesController < ApplicationController
  def index
    user = User.find(session[:user_id])
    render json: user.update_activities
  end
end
