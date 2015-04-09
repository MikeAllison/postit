class UsersController < ApplicationController
  before_action :authenticate, except: [:new, :create]
  before_action :find_user, only: [:show, :edit, :update]

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

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully."
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end

    def find_user
      @user = User.find(params[:id])
    end
end