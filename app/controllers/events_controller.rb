class EventsController < ApplicationController
  def create
    event = Event.new(create_params)
    event.user_id = session[:user_id]

    if event.save
      body = event
      status = 201
    else
      body = event.errors
      status = 400
      raise "Failed event creation. \
        Params: #{params}. Errors: #{event.errors}."
    end

  rescue StandardError => e
    Rails.logger.debug e
  ensure
    render json: body.as_json, status: status
  end

  def update
    event = Event.find_by(id: params[:id],
      user_id: session[:user_id])

    if event.nil?
      status = 404
      raise "Failed event update. \
        Params: #{params}. Session user_id: #{session[:user_id]}."
    elsif event.update(create_params)
      body = event
      status = 200
    else
      body = event.errors
      status = 400
      raise "Failed event creation. \
        Params: #{params}. Errors: #{event.errors}."
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
end
