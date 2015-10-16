class WelcomeController < ApplicationController
  skip_before_filter :require_login, only: :index

  def index
    redirect_to user_path(session[:user_id]) if session[:user_id]
  end
end
