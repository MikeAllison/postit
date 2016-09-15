require 'test_helper'

class SessionIntegrationTest < ActionDispatch::IntegrationTest
  # Login
  test '/login route' do
    get login_path

    assert_response :success
    assert_generates '/login', controller: :sessions, action: :new
  end

  test 'a user can log in successfully' do
    create_standard_user

    post login_path, { username: 'user', password: 'password' }

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

  # Logout
  test 'user can log out' do
    login(create_standard_user)

    get logout_path

    assert_nil session[:current_user_id]
    assert_equal 'You have logged out successfully.', flash[:success]
    assert_redirected_to root_path
  end

  # Disabled Accounts
  test 'a disabled user cannot log in' do
    user = create_standard_user
    user.disabled = true
    user.save

    login(user)

    assert_nil session[:current_user_id]
    assert_redirected_to login_path
    assert_equal 'Your account has been disabled.', flash[:danger]
  end

  test 'session will be destroyed if user account is disabled' do
    user = login(create_standard_user)

    assert_redirected_to posts_path

    user.disabled = true
    user.save

    get new_post_path
    assert_redirected_to login_path
    assert_equal nil, session[:current_user_id]
    assert_equal 'Your account has been disabled.', flash[:danger]
  end
end
