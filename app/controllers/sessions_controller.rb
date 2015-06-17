class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where("lower(username) = ?", params[:username].downcase).first

    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      flash[:success] = "You have logged in successfully."
      redirect_to posts_path
    else
      flash.now[:danger] = "The username or password was incorrect."
      render :new
    end
  end

  def destroy
    flash[:success] = "You have logged out successfully." if logged_in?
    @current_user = session[:current_user_id] = nil
    redirect_to root_path
  end
end
