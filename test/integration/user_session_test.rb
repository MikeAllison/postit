require 'test_helper'

class UserSessionTest < ActionDispatch::IntegrationTest
  test 'a disabled user cannot log in' do
    u = create_standard_user
    u.disabled = true
    u.save

    log_in_standard_user

    assert_nil session[:current_user_id]
    assert_redirected_to login_path
    assert_equal 'Your account has been disabled.', flash[:danger]
  end

  test 'destroy_session_if_user_disabled' do
    u = create_standard_user

    log_in_standard_user

    assert_redirected_to posts_path

    u.disabled = true
    u.save

    get new_post_path
    assert_redirected_to login_path
    assert_equal nil, session[:current_user_id]
    assert_equal 'Your account has been disabled.', flash[:danger]
  end

  test 'user can log in with correct credentials' do
    create_standard_user
    log_in_standard_user

    assert_not_nil session[:current_user_id]
    assert_redirected_to posts_path
    assert_equal 'You have logged in successfully.', flash[:success]
  end

  test 'user cannot log in with incorrect password' do
    create_standard_user

    post login_path, { username: 'auser', password: 'badpassword' }

    assert_nil session[:current_user_id]
    assert_template :new
    assert_equal 'The username or password was incorrect.', flash[:danger]
  end

  test 'user cannot log in with an unknown username' do
    post login_path, { username: 'notuser', password: 'password' }

    assert_nil session[:current_user_id]
    assert_template :new
    assert_equal 'The username or password was incorrect.', flash[:danger]
  end

  test 'user can log out' do
    create_standard_user
    log_in_standard_user

    get logout_path

    assert_nil session[:current_user_id]
    assert_equal 'You have logged out successfully.', flash[:success]
    assert_redirected_to root_path
  end
end
