class SessionsController < ApplicationController
  before_action :redirect_logged_in, only: [:new]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if user.nil?
      render :new
    else
      login_user!(user)
      redirect_to user_url(user)
    end
  end

  def destroy
    return if current_user.nil?
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end

  private

  def redirect_logged_in
    redirect_to cats_url if current_user
  end
end
