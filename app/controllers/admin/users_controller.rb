class Admin::UsersController < ApplicationController
  before_action :authenticate
  before_action :require_admin
  before_action :find_user, only: [:update_role]
  before_action :block_current_user, only: [:update_role] # AppController

  def index
    @users = User.all
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
      format.js
    end
  end

  private

  def find_user
    @user = User.find_by!(slug: params[:id])
  end
end
