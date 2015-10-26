require_relative '../../lib/date_helpers'

class EventsController < ApplicationController
  before_action :transform_time, only: [:create]

  def new
    @event = Event.new()
  end

  # ajax create method
    # def create
    #   event = Event.new(create_params)
    #   event.user_id = session[:user_id]

    #   if event.save
    #     body = event
    #     status = 201
    #   else
    #     body = event.errors
    #     status = 400
    #     raise 'Failed event creation. ' +
    #       "Params: #{params}. Errors: #{event.errors}."
    #   end

    # rescue StandardError => e
    #   Rails.logger.debug e
    # ensure
    #   render json: body.as_json, status: status
    # end
  #

  def create
    @event = Event.new(create_params)
    @event.user_id = session[:user_id]

    if @event.save
      redirect_to user_path(session[:user_id])
    else
      render :new
    end
  end

  def update
    event = Event.find_by(id: params[:id],
      user_id: session[:user_id])

    if event.nil?
      status = 404
      raise 'Failed event update. ' +
        "Params: #{params}. Session user_id: #{session[:user_id]}."
    elsif event.update(create_params)
      body = event
      status = 200
    else
      body = event.errors
      status = 400
      raise 'Failed event creation. ' +
        "Params: #{params}. Errors: #{event.errors}."
    end

  rescue StandardError => e
    Rails.logger.debug e
  ensure
    render json: body.as_json, status: status
  end

  private

  def create_params
    params.require(:event).permit(:time, :rating, :note, :event_type_id)
  end

  # NOTE: depending on implementation, update may need time transformed as well.
  def transform_time
    if params[:event][:time]
      params[:event][:time] = DateHelpers.parse_to_ms(params[:event][:time])
    end
  end
end
