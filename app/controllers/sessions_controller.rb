class SessionsController < ApplicationController
  before_action :prevent_login_if_user_disabled, only: [:create]

  def new
  end

  def create
    user = User.find_by('lower(username) = ?', params[:username].downcase)

    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      flash[:success] = 'You have logged in successfully.'
      redirect_to posts_path
    else
      flash.now[:danger] = 'The username or password was incorrect.'
      render :new
    end
  end

  def destroy
    @current_user = session[:current_user_id] = nil
    flash[:success] = 'You have logged out successfully.' if logged_in?
    redirect_to root_path
  end

  private

  def prevent_login_if_user_disabled
    user = User.find_by('lower(username) = ?', params[:username].downcase)

    if user.disabled?
      @current_user = session[:current_user_id] = nil
      flash[:danger] = 'Your account has been disabled.'
      redirect_to root_path
    end
  end
end
