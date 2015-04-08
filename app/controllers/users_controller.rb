class UsersController < ApplicationController
  before_action :authenticate, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:current_user_id] = @user.id
      flash[:success] = "Your account has been created."
      redirect_to posts_path
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
