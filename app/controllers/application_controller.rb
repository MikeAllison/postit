class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_action :catch_not_found

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
        flash[:danger] = "You must sign in to access that page."
        redirect_to login_path
      end
    end

    # Redirects ActiveRecord::RecordNotFound to root_path
    def catch_not_found
      yield
      rescue ActiveRecord::RecordNotFound
        flash[:warning] = "Sorry, the page that you are looking for doesn't exist."
        redirect_to root_path
    end
end
