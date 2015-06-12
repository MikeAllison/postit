class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_action :set_time_zone, if: :logged_in?
  around_action :catch_not_found
  around_action :catch_redirect_back

  helper_method :current_user, :logged_in?

  protected

    def current_user
      @current_user ||= User.find_by(id: session[:current_user_id]) if session[:current_user_id]
    end

    def logged_in?
      !!current_user
    end

    def authenticate
      unless logged_in?
        respond_to do |format|
          format.html { redirect_to login_path, flash: { danger: "You must log in to access that page." } }
          format.js { render js: 'bootbox.alert("You must log in to access that page.");' }
        end
      end
    end

    def restrict_to_moderators
      unless current_user.moderator?
        respond_to do |format|
          format.html { redirect_to :back, flash: { danger: "This action requires moderator rights." } }
          format.js { render js: 'bootbox.alert("This action requires moderator rights.");' }
        end
      end
    end

    def restrict_to_admins
      unless current_user.admin?
        respond_to do |format|
          format.html { redirect_to :back, flash: { danger: "This action requires administrator rights." } }
          format.js { render js: 'bootbox.alert("This action requires administrator rights.");' }
        end
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
end
