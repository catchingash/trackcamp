class SessionsController < ApplicationController
  # this is required for the OmniAuth Developer Strategy
  skip_before_filter :verify_authenticity_token, only: :create, :if => proc { |c| Rails.env.development? }

  def create
    auth_hash = request.env['omniauth.auth']

    # FIXME: save user data to DB.

    render json: auth_hash
  end

end
