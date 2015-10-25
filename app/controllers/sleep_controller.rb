require_relative '../../lib/csv_parser'

class SleepController < ApplicationController
  def index
    user = User.find(session[:user_id])
    render json: user.sleep.order(:started_at).as_json, status: :ok
  end

  def new; end

  def create
    SleepBotCSVParser.create_sleep_records(session[:user_id], file, utc_offset)
    redirect_to user_path(session[:user_id])
    # TODO: add error handling
  end

  private

  def file
    params.require(:file)
  end

  def utc_offset
    params.require(:time_zone).require(:utc_offset)
  end
end
