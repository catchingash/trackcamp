class ActivitiesController < ApplicationController
  def index
    render json: @user.activities_by_date.as_json, status: :ok
  end
end
