require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'a disabled user cannot log in' do
    u = User.create(username: 'auser', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    u.disabled = true
    u.save

    post login_path, { username: 'auser', password: 'password' }

    assert_equal nil, session[:current_user_id]
    assert_redirected_to login_path
    assert_equal 'Your account has been disabled.', flash[:danger]
  end
end
