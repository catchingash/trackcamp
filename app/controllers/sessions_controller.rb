class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create, :if => proc { |c| Rails.env.development? } # this is required for the OmniAuth Developer Strategy
  before_action :find_or_create_user, only: :create

  def create
    session[:user_id] = @user.id
    flash[:message] = { success: "You have logged in!" }
    redirect_to root_path # FIXME: decide if the root path is the place to send someone after they're logged in.
  end

  private

  def find_or_create_user
    params = create_params
    @user = User.create_with(params)
      .find_or_create_by(uid: params[:uid])

    # TODO: Update refresh token

    unless @user.persisted?
      flash[:error] = { error: "We don't know what happened. We're very very sorry! >_>" }
      redirect_to root_path
    end
  end

  def create_params
    auth_hash = request.env['omniauth.auth']

    {
      uid: auth_hash['uid'],
      email: auth_hash['info']['email'],
      refresh_token: auth_hash['credentials']['refresh_token']
    }
  end
end
