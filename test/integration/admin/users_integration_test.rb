require 'test_helper'

class Admin::UsersIntegrationTest < ActionDispatch::IntegrationTest
  # admin/users#index
  test 'must authenticate for admin/users#index' do
    get admin_users_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/users#index' do
    login(create_moderator_user)

    get admin_users_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/users#index' do
    login(create_standard_user)

    get admin_users_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can access admin/users#index' do
    login(create_admin_user)

    get admin_users_path

    assert_response :success
    assert assigns :users
  end

  test 'searching for an existing user' do
    u = create_standard_user
    login(create_admin_user)

    get admin_users_path, { username: u.username }

    assert_response :success
    users_collection = assigns :users
    assert_includes(users_collection, u)
  end

  test 'searching for a nonexistant user' do
    login(create_admin_user)

    get admin_users_path, { username: 'notauser' }

    assert_response :success
    assert_template :index
    assert_equal 'Your search returned no results.', flash[:warning]
  end

  # admin/users#update_role
  test 'must authenticate for admin/users#update_role' do
    patch update_role_admin_user_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/users#update_role' do
    login(create_moderator_user)

    patch update_role_admin_user_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/users#update_role' do
    login(create_standard_user)

    patch update_role_admin_user_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can update a user role via HTTP' do
    u = create_standard_user
    login(create_admin_user)

    # Moderator
    patch update_role_admin_user_path(id: u.slug), { role: 'moderator' }

    u.reload
    assert u.moderator?
    assert_redirected_to admin_users_path

    # Admin
    patch update_role_admin_user_path(id: u.slug), { role: 'admin' }

    u.reload
    assert u.admin?
    assert_redirected_to admin_users_path
  end

  test 'admins can update a user role via AJAX' do
    u = create_standard_user
    login(create_admin_user)

    # Moderator
    patch update_role_admin_user_path(id: u.slug), { role: 'moderator' }, xhr: true

    u.reload
    assert u.moderator?

    # Admin
    patch update_role_admin_user_path(id: u.slug), { role: 'admin' }, xhr: true

    u.reload
    assert u.admin?
  end

  test 'admins cannot change their own role via HTTP' do
    u = login(create_admin_user)

    # Moderator
    patch update_role_admin_user_path(id: u.slug), { role: 'user' }

    u.reload
    assert u.admin?
    assert_equal 'This action cannot be performed under your account.', flash[:danger]

    # User
    patch update_role_admin_user_path(id: u.slug), { role: 'moderator' }

    u.reload
    assert u.admin?
    assert_equal 'This action cannot be performed under your account.', flash[:danger]
  end

  test 'admins cannot change their own role via AJAX' do
    u = login(create_admin_user)

    # Moderator
    patch update_role_admin_user_path(id: u.slug), { role: 'user' }, xhr: true

    u.reload
    assert u.admin?
    assert_equal 'This action cannot be performed under your account.', flash[:danger]

    # User
    patch update_role_admin_user_path(id: u.slug), { role: 'moderator' }, xhr: true

    u.reload
    assert u.admin?
    assert_equal 'This action cannot be performed under your account.', flash[:danger]
  end

  test 'user role must be valid' do
    u = create_standard_user
    login(create_admin_user)

    # via HTTP
    patch update_role_admin_user_path(id: u.slug), { role: 'notavalidrole' }

    u.reload
    assert u.user?
    assert_redirected_to admin_users_path
    assert_equal 'That is not a valid role.', flash[:danger]

    # via AJAX
    patch update_role_admin_user_path(id: u.slug), { role: 'notavalidrole' }, xhr: true

    u.reload
    assert u.user?
    assert_equal 'That is not a valid role.', flash[:danger]
  end

  # admin/users#toggle_disabled
  test 'must authenticate for admin/users#toggle_disabled' do
    patch toggle_disabled_admin_user_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/users#toggle_disabled' do
    login(create_moderator_user)

    patch toggle_disabled_admin_user_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/users#toggle_disabled' do
    login(create_standard_user)

    patch toggle_disabled_admin_user_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can disable an account via HTTP' do
    u = create_standard_user
    login(create_admin_user)

    patch toggle_disabled_admin_user_path(id: u.slug)

    u.reload
    assert u.disabled?
    assert_redirected_to admin_users_path
  end

  test 'admins can disable an account via AJAX' do
    u = create_standard_user
    login(create_admin_user)

    patch toggle_disabled_admin_user_path(id: u.slug), xhr: true

    u.reload
    assert u.disabled?
  end

  test 'admins can enable an account via HTTP' do
    u = create_standard_user
    u.disable!
    login(create_admin_user)

    patch toggle_disabled_admin_user_path(id: u.slug)

    u.reload
    assert_not u.disabled?
    assert_redirected_to admin_users_path
  end

  test 'admins can enable an account via AJAX' do
    u = create_standard_user
    u.disable!
    login(create_admin_user)

    patch toggle_disabled_admin_user_path(id: u.slug), xhr: true

    u.reload
    assert_not u.disabled?
  end

  test 'admins cannot disable their own account' do
    u = login(create_admin_user)

    # via HTTP
    patch toggle_disabled_admin_user_path(id: u.slug)

    u.reload
    assert_not u.disabled?
    assert_equal 'This action cannot be performed under your account.', flash[:danger]

    # via AJAX
    patch toggle_disabled_admin_user_path(id: u.slug), xhr: true

    u.reload
    assert_not u.disabled?
    assert_equal 'This action cannot be performed under your account.', flash[:danger]
  end
end
