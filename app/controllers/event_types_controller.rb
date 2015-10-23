class EventTypesController < ApplicationController
  def create
    event_type = EventType.new(create_params)
    event_type.user_id = session[:user_id]

    if event_type.save
      body = event_type
      status = 201
    else
      body = event_type.errors
      status = 400
      raise "Failed event type creation. Params: #{params}. Errors: #{event_type.errors}."
    end

  rescue StandardError => e
    Rails.logger.debug e
  ensure
    render json: body.as_json, status: status
  end

  def update
    event_type = EventType.find_by(id: params[:id])

    if event_type.nil? || event_type.user_id != session[:user_id]
      status = 404
      raise "Failed event type update. Event exists: #{!!event_type}. Event user_id: #{params[:id]}. Session user_id: #{session[:user_id]}."
    elsif event_type.update(create_params)
      body = event_type
      status = 200
    else
      body = event_type.errors
      status = 400
      raise "Failed event type creation. Params: #{params}. Errors: #{event_type.errors}."
    end

  rescue StandardError => e
    Rails.logger.debug e
  ensure
    render json: body.as_json, status: status
  end

  private

  def create_params
    params.require(:event_type).permit(:name)
  end
end
