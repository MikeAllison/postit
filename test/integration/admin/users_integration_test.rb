require 'test_helper'

class Admin::UsersIntegrationTest < ActionDispatch::IntegrationTest
  test 'must authenticate for admin/users#update_role' do
    patch update_role_admin_user_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/users#update_role' do
    create_moderator_user
    log_in_moderator_user

    patch update_role_admin_user_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/users#update_role' do
    create_standard_user
    log_in_standard_user

    patch update_role_admin_user_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'must authenticate for admin/users#toggle_disabled' do
    patch toggle_disabled_admin_user_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/users#toggle_disabled' do
    create_moderator_user
    log_in_moderator_user

    patch toggle_disabled_admin_user_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/users#toggle_disabled' do
    create_standard_user
    log_in_standard_user

    patch toggle_disabled_admin_user_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'must authenticate for admin/users#index' do
    get admin_users_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/users#index' do
    create_moderator_user
    log_in_moderator_user

    get admin_users_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/users#index' do
    create_standard_user
    log_in_standard_user

    get admin_users_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end
end
