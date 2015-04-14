class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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
end
