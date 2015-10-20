class ActivitiesController < ApplicationController
  def index
    user = User.find(session[:user_id])
    render json: user.activities_by_date.as_json, status: :ok
  end
end
