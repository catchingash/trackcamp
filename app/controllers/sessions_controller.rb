class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create, :if => proc { |c| Rails.env.development? } # this is required for the OmniAuth Developer Strategy
  skip_before_filter :require_login, only: :create
  before_action :find_or_create_user, only: :create

  def create
    session[:user_id] = @user.id
    flash[:message] = { success: "You have logged in!" }
    redirect_to user_path(@user.id)
  end

  # NOTE: any updates to this method should also be included in users#destroy
  def destroy
    session[:user_id] = nil
    flash[:message] = { success: "You have signed out!" }
    redirect_to root_path
  end

  private

  def find_or_create_user
    params = create_params
    @user = User.create_with(params)
      .find_or_create_by(uid: params[:uid])

    @user.update(refresh_token: params[:refresh_token]) # OPTIMIZE: this isn't ideal because new users don't need this to be updated

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
      refresh_token: auth_hash['credentials']['token']
    }
  end
end
