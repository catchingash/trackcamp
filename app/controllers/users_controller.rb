class UsersController < ApplicationController
  before_action :verify_authenticated_user

  def show; end

  def destroy
    User.find(session[:user_id]).destroy
    flash[:message] = { success: 'You have permanently deleted your account and all associated data.' }

    # don't forget to log out the now-deleted user
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def verify_authenticated_user
    redirect_to user_path(session[:user_id]) if session[:user_id] != params[:id].to_i
  end

end
