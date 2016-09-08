class Admin::UsersController < ApplicationController
  before_action :authenticate
  before_action :require_admin
  before_action :find_user, only: [:update_role, :toggle_disabled]
  before_action :block_current_user, only: [:update_role, :toggle_disabled] # AppController

  def index
    @users = User.search(params[:username])

    if @users.empty?
      flash.now[:warning] = 'Your search returned no results.'
    end
  end

  def update_role
    if params[:role] == 'moderator'
      !@user.moderator? ? @user.moderator! : @user.user!
    elsif params[:role] == 'admin'
      !@user.admin? ? @user.admin! : @user.user!
    else
      flash[:danger] = @error_msg = 'That is not a valid role.'
    end

    respond_to do |format|
      format.html { redirect_to admin_users_path }
      format.js { render 'update_user_details' }
    end
  end

  def toggle_disabled
    @user.disabled? ? @user.enable! : @user.disable!

    respond_to do |format|
      format.html { redirect_to admin_users_path }
      format.js { render 'update_user_details' }
    end
  end

  def search
    binding.pry
  end

  private

  def find_user
    @user = User.find_by!(slug: params[:id])
  end
end
