class ActivitiesController < ApplicationController
  def index
    user = User.find(session[:user_id])
    render json: user.update_and_return_activities
  end
end
