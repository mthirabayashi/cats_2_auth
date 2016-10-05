class UsersController < ApplicationController
  before_action :redirect_logged_in, only: [:create]

  def new

  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def create
    user = User.new(user_params)
    if user.save
      login_user!(user)
      redirect_to user_url(user)
    else
      redirect_to new_session_url
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  def redirect_logged_in
    redirect_to cats_url if current_user
  end
end
