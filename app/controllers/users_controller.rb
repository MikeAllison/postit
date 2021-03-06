class UsersController < ApplicationController
  before_action :authenticate, except: [:new, :create, :show] # AppController
  before_action :find_user, only: [:show, :edit, :update]
  before_action :require_current_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:current_user_id] = @user.id
      flash[:success] = 'Your account has been created.'
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
      flash[:success] = 'Your account was updated successfully.'
      redirect_to current_user.reload
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation,
                                 :time_zone)
  end

  def find_user
    @user = User.find_by!(slug: params[:id])
  end

  def require_current_user
    return unless @user != current_user
    flash[:danger] = 'Access Denied! - You may only edit your own profile.'
    redirect_to current_user
  end
end
