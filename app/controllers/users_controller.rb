class UsersController < ApplicationController
  before_action :verify_authenticated_user

  def show; end

  private

  def verify_authenticated_user
    redirect_to user_path(session[:user_id]) if session[:user_id] != params[:id].to_i
  end

end
