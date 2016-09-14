require 'test_helper'

class Admin::CategoriesIntegrationTest < ActionDispatch::IntegrationTest
  test 'must authenticate for admin/categories#toggle_hidden' do
    patch toggle_hidden_admin_category_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#toggle_hidden' do
    create_moderator_user
    log_in_moderator_user

    patch toggle_hidden_admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#toggle_hidden' do
    create_standard_user
    log_in_standard_user

    patch toggle_hidden_admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'must authenticate for admin/categories#index' do
    get admin_categories_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#index' do
    create_moderator_user
    log_in_moderator_user

    get admin_categories_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#index' do
    create_standard_user
    log_in_standard_user

    get admin_categories_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'must authenticate for admin/categories#create' do
    post admin_categories_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#create' do
    create_moderator_user
    log_in_moderator_user

    post admin_categories_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#create' do
    create_standard_user
    log_in_standard_user

    post admin_categories_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'must authenticate for admin/categories#new' do
    get new_admin_category_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#new' do
    create_moderator_user
    log_in_moderator_user

    get new_admin_category_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#new' do
    create_standard_user
    log_in_standard_user

    get new_admin_category_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'must authenticate for admin/categories#edit' do
    get edit_admin_category_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#edit' do
    create_moderator_user
    log_in_moderator_user

    get edit_admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#edit' do
    create_standard_user
    log_in_standard_user

    get edit_admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'must authenticate for admin/categories#update PATCH' do
    patch admin_category_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#update PATCH' do
    create_moderator_user
    log_in_moderator_user

    patch admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#update PATCH' do
    create_standard_user
    log_in_standard_user

    patch admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'must authenticate for admin/categories#update PUT' do
    put admin_category_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#update PUT' do
    create_moderator_user
    log_in_moderator_user

    put admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#update PUT' do
    create_standard_user
    log_in_standard_user

    put admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end
end
