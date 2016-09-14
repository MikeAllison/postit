require 'test_helper'

class UserRegistrationTest < ActionDispatch::IntegrationTest
  setup do
    get register_path

    assert_response :success
    assert_generates '/register', controller: :users, action: :new

    assert_select 'form#new_user' do
      assert_select 'input#user_username'
      assert_select 'input#user_password'
      assert_select 'input#user_password_confirmation'
      assert_select 'select#user_time_zone'
      assert_select 'button', 'Register'
    end
  end

  test 'a user can register successfully' do
    assert_difference('User.count') do
      post users_path, { user: {
        username: 'user',
        password: 'password',
        password_confirmation: 'password',
        time_zone: 'Eastern Time (US & Canada)'
      } }
    end

    assert session[:current_user_id]
    assert_redirected_to posts_path
    assert_equal 'Your account has been created.', flash[:success]
  end

  test 'an unsuccessful registration from mismatched passwords' do
    assert_no_difference('User.count') do
      post users_path, { user: {
        username: 'user',
        password: 'password',
        password_confirmation: '',
        time_zone: 'Eastern Time (US & Canada)'
      } }
    end

    assert_not session[:current_user_id]
    assert_template :new
  end

  test 'an unsuccessful registration from a duplicate username' do
    create_standard_user

    assert_no_difference('User.count') do
      post users_path, { user: {
        username: 'user',
        password: 'password',
        password_confirmation: 'password',
        time_zone: 'Eastern Time (US & Canada)'
      } }
    end

    assert_not session[:current_user_id]
    assert_template :new
  end
end
