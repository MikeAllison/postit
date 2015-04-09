class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      flash[:success] = "You have logged in successfully."
      redirect_to posts_path
    else
      flash[:danger] = "The username or password was incorrect."
      redirect_to login_path
    end
  end

  def destroy
    @current_user = session[:current_user_id] = nil
    flash[:success] = "You have been logged out successfully."
    redirect_to root_path
  end
end