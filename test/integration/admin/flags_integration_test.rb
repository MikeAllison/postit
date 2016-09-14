require 'test_helper'

class Admin::FlagsIntegrationTest < ActionDispatch::IntegrationTest
  test 'must authenticate for admin/flags#index' do
    get admin_flags_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/flags#index' do
    create_moderator_user
    log_in_moderator_user

    get admin_flags_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/flags#index' do
    create_standard_user
    log_in_standard_user

    get admin_flags_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can access admin/flags#index' do
    create_admin_user
    log_in_admin_user

    get admin_flags_path

    assert_response :success
  end
end
