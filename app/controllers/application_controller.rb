class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :destroy_session_if_user_disabled
  around_action :set_time_zone, if: :logged_in?
  around_action :catch_not_found
  around_action :catch_redirect_back

  helper_method :current_user, :logged_in?

  # Catch all for missing route
  def catch_routing_error
    flash[:warning] = "Sorry, the page that you are looking for doesn't exist."
    redirect_to root_path
  end

  protected

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id]) if session[:current_user_id]
  end

  def logged_in?
    !!current_user
  end

  def authenticate
    return if logged_in?
    respond_to do |format|
      format.html { redirect_to login_path, flash: { danger: 'You must log in to access that page.' } }
      format.js { render js: 'bootbox.alert("You must log in to access that page.");' }
    end
  end

  def block_current_user
    return unless @user == current_user
    respond_to do |format|
      format.html { redirect_to :back, flash: { danger: 'This action cannot be performed under your account.' } }
      format.js { render js: 'bootbox.alert("This action cannot be performed under your account.");' }
    end
  end

  def require_moderator
    return if current_user.moderator?
    respond_to do |format|
      format.html { redirect_to :back, flash: { danger: 'This action requires moderator rights.' } }
      format.js { render js: 'bootbox.alert("This action requires moderator rights.");' }
    end
  end

  def require_admin
    return if current_user.admin?
    respond_to do |format|
      format.html { redirect_to :back, flash: { danger: 'This action requires administrator rights.' } }
      format.js { render js: 'bootbox.alert("This action requires administrator rights.");' }
    end
  end

  def require_moderator_or_admin
    return if current_user.moderator? || current_user.admin?
    respond_to do |format|
      format.html { redirect_to :back, flash: { danger: 'This action requires moderator, or administrator, rights.' } }
      format.js { render js: 'bootbox.alert("This action requires moderator, or administrator, rights.");' }
    end
  end

  def set_time_zone
    Time.use_zone(current_user.time_zone) { yield }
  end

  # Redirects ActiveRecord::RecordNotFound to root_path
  def catch_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    flash[:warning] = "Sorry, the page that you are looking for doesn't exist."
    redirect_to root_path
  end

  # Redirects ActionController::RedirectBackError to root_path
  def catch_redirect_back
    yield
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def destroy_session_if_user_disabled
    if logged_in? && current_user.disabled?
      @current_user = session[:current_user_id] = nil
      flash[:danger] = 'Your account has been disabled.'
      redirect_to login_path
    end
  end

  private

  def catch_invalid_params
    if (params[action_name] != 'true') && (params[action_name] != 'false')
      @error_msg = "Sorry, there was a problem submitting your #{action_name}.  Please try again."

      respond_to do |format|
        format.html do
          flash[:danger] = @error_msg
          redirect_to :back
        end
        format.js { render "shared/#{action_name}", locals: { obj: @comment.reload } }
      end
    end
  end
end
