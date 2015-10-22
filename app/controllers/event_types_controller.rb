class EventTypesController < ApplicationController
  def create
    event_type = EventType.new(create_params)

    if event_type.save
      body = event_type
      status = 201
    else
      body = event_type.errors
      status = 400
      raise "Failed event type creation. Params: #{create_params}. Errors: #{event_type.errors}."
    end

  rescue StandardError => e
    Rails.logger.debug e
  ensure
    render json: body.as_json, status: status
  end

  def update
  end

  private

  def create_params
    c_params = params.require(:event_type).permit(:name)
    c_params[:user_id] = session[:user_id]
    return c_params
  end
end
