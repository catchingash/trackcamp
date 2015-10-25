class SessionsController < ApplicationController
  # this is required for the OmniAuth Developer Strategy
  skip_before_action :verify_authenticity_token,
    only: :create, :if => proc { Rails.env.development? }

  skip_before_action :require_login, only: :create
  before_action :find_or_create_user, only: :create

  def create
    @user.update_all # OPTIMIZE: it'd be really great if this were asynchronous
    session[:user_id] = @user.id
    session[:time_zone] = @user.time_zone
    redirect_to user_path(@user.id)
  end

  # NOTE: any updates to this method should also be included in users#destroy
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def find_or_create_user
    params = create_params
    @user = User.create_with(params).find_or_create_by(uid: params[:uid])

    # OPTIMIZE: this isn't ideal because new users don't need this to be updated
    @user.update(refresh_token: params[:refresh_token])

    redirect_to root_path unless @user.persisted?
  end

  def create_params
    auth_hash = request.env['omniauth.auth']

    {
      uid: auth_hash['uid'],
      email: auth_hash['info']['email'],
      refresh_token: auth_hash['credentials']['token']
    }
  end
end
