require 'test_helper'

class UserIntegrationTest < ActionDispatch::IntegrationTest
  # Registration (users#new and users#create)
  test '/register route' do
    get register_path

    assert_response :success
    assert_generates '/register', controller: :users, action: :new
  end

  test 'a successful registration' do
    assert_difference('User.count', 1) do
      post users_path, { user: {
        username: 'user',
        password: 'password',
        password_confirmation: 'password',
        time_zone: 'Eastern Time (US & Canada)'
      } }
    end

    assert_not_nil session[:current_user_id]
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

    assert_nil session[:current_user_id]
    assert_template :new
  end

  test 'an unsuccessful registration from a duplicate username' do
    create_standard_user

    assert_no_difference('User.count') do
      post users_path, { user: {
        username: 'user1',
        password: 'password',
        password_confirmation: 'password',
        time_zone: 'Eastern Time (US & Canada)'
      } }
    end

    assert_nil session[:current_user_id]
    assert_template :new
  end

  # users#show
  test 'an unauthenticated user can view a user profile' do
    user = create_standard_user

    get user_path(id: user.slug)

    assert_response :success
    assert assigns :user
  end

  test 'an authenticated user can view a user profile' do
    user = create_standard_user

    login(create_standard_user(2))

    get user_path(id: user.slug)

    assert_response :success
    assert assigns :user
  end

  # users#edit
  test 'an unauthenticated user cannot access users#edit' do
    get edit_user_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user cannot edit a different users profile' do
    user1 = create_standard_user
    user2 = create_standard_user(2)

    login(user2)

    get edit_user_path(id: user1.slug)

    assert_redirected_to user_path(id: user2.slug)
    assert_equal 'Access Denied! - You may only edit your own profile.', flash[:danger]
  end

  test 'an authenticated user can edit their own profile' do
    user = login(create_standard_user)

    get edit_user_path(id: user.slug)

    assert_response :success
    assert assigns :user
  end

  # users#update
  test 'an unauthenticated user cannot access users#update via PATCH' do
    patch user_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user cannot update another users profile via PATCH' do
    user1 = create_standard_user
    user2 = login(create_standard_user(2))

    patch user_path(id: user1.slug)

    assert_redirected_to user_path(id: user2.slug)
    assert_equal 'Access Denied! - You may only edit your own profile.', flash[:danger]
  end

  test 'an authenticated can update their own profile via PATCH' do
    user = login(create_standard_user)

    patch user_path(id: user.slug), { user: {
      username: 'newusername',
      password: 'newpassword',
      password_confirmation: 'newpassword',
      time_zone: 'Pacific Time (US & Canada)'
    } }

    user.reload
    assert_equal 'newusername', user.username
    assert_equal 'Pacific Time (US & Canada)', user.time_zone
    assert_redirected_to user_path(id: user.slug)
    assert_equal 'Your account was updated successfully.', flash[:success]
  end

  test 'an unauthenticated user cannot access users#update via PUT' do
    put user_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user cannot update another users profile via PUT' do
    user1 = create_standard_user
    user2 = login(create_standard_user(2))

    put user_path(id: user1.slug)

    assert_redirected_to user_path(id: user2.slug)
    assert_equal 'Access Denied! - You may only edit your own profile.', flash[:danger]
  end

  test 'an authenticated can update their own profile via PUT' do
    user = login(create_standard_user)

    put user_path(id: user.slug), { user: {
      username: 'newusername',
      password: 'newpassword',
      password_confirmation: 'newpassword',
      time_zone: 'Pacific Time (US & Canada)'
    } }

    user.reload
    assert_equal 'newusername', user.username
    assert_equal 'Pacific Time (US & Canada)', user.time_zone
    assert_redirected_to user_path(id: user.slug)
    assert_equal 'Your account was updated successfully.', flash[:success]
  end

  test 'a failed attempt at updating a user profile via PATCH' do
    user = login(create_standard_user)

    patch user_path(id: user.slug), { user: {
      time_zone: 'invalidtimezone'
    } }

    assert_template :edit
  end

  test 'a failed attempt at updating a user profile via PUT' do
    user = login(create_standard_user)

    put user_path(id: user.slug), { user: {
      time_zone: 'invalidtimezone'
    } }

    assert_template :edit
  end
end
