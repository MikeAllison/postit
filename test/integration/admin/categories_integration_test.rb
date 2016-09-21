require 'test_helper'

class Admin::CategoriesIntegrationTest < ActionDispatch::IntegrationTest
  # admin/categories#index
  test 'must authenticate for admin/categories#index' do
    get admin_categories_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#index' do
    login(create_moderator_user)

    get admin_categories_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#index' do
    login(create_standard_user)

    get admin_categories_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can access admin/categories#index' do
    login(create_admin_user)

    get admin_categories_path

    assert_response :success
    assert assigns :categories
  end

  # admin/categories#new
  test 'must authenticate for admin/categories#new' do
    get new_admin_category_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#new' do
    login(create_moderator_user)

    get new_admin_category_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#new' do
    login(create_standard_user)

    get new_admin_category_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can access admin/categories#new' do
    login(create_admin_user)

    get new_admin_category_path

    assert_response :success
    assert assigns :category
  end

  # admin/categories#create
  test 'must authenticate for admin/categories#create' do
    post admin_categories_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#create' do
    login(create_moderator_user)

    post admin_categories_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#create' do
    login(create_standard_user)

    post admin_categories_path

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can create a new category' do
    login(create_admin_user)

    assert_difference('Category.count', 1) do
      post admin_categories_path, { category: { name: 'News' } }
    end

    assert_redirected_to admin_categories_path
    assert_equal 'A new category was created.', flash[:success]
  end

  # admin/categories#edit
  test 'must authenticate for admin/categories#edit' do
    get edit_admin_category_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#edit' do
    login(create_moderator_user)

    get edit_admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#edit' do
    login(create_standard_user)

    get edit_admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can access admin/categories#edit' do
    cat = create_persisted_category

    login(create_admin_user)

    get admin_category_path(id: cat.id
)

    assert_response :found
  end

  # admin/categories#update (PATCH)
  test 'must authenticate for admin/categories#update PATCH' do
    patch admin_category_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#update PATCH' do
    login(create_moderator_user)

    patch admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#update PATCH' do
    login(create_standard_user)

    patch admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can update a category with PATCH' do
    cat = create_persisted_category

    login(create_admin_user)

    patch admin_category_path(id: cat.slug), category: { name: 'Updated' }

    cat.reload
    assert_equal 'Updated', cat.name
    assert_redirected_to admin_categories_path
    assert_equal 'The category was updated.', flash[:success]
  end

  # admin/categories#update (PUT)
  test 'must authenticate for admin/categories#update PUT' do
    put admin_category_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#update PUT' do
    login(create_moderator_user)

    put admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#update PUT' do
    login(create_standard_user)

    put admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can update a category with PUT' do
    cat = create_persisted_category

    login(create_admin_user)

    put admin_category_path(id: cat.slug), category: { name: 'Updated' }

    cat.reload
    assert_equal 'Updated', cat.name
    assert_redirected_to admin_categories_path
    assert_equal 'The category was updated.', flash[:success]
  end

  # admin/categories#toggle_hidden
  test 'must authenticate for admin/categories#toggle_hidden' do
    patch toggle_hidden_admin_category_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'moderators cannot access admin/categories#toggle_hidden' do
    login(create_moderator_user)

    patch toggle_hidden_admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'users cannot access admin/categories#toggle_hidden' do
    login(create_standard_user)

    patch toggle_hidden_admin_category_path(id: 1)

    assert_redirected_to root_path
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can hide a category via HTTP' do
    cat = create_persisted_category

    login(create_admin_user)

    patch toggle_hidden_admin_category_path(id: cat.slug)
    assert_response :found
    assert_redirected_to admin_categories_path
    cat.reload
    assert cat.hidden?
  end

  test 'admins can hide a category via AJAX' do
    cat = create_persisted_category

    login(create_admin_user)

    patch toggle_hidden_admin_category_path(id: cat.slug), xhr: true
    assert_response :found
    assert_redirected_to admin_categories_path
    cat.reload
    assert cat.hidden?
  end

  test 'admins can unhide a category via HTTP' do
    cat = create_persisted_category

    cat.hide!
    login(create_admin_user)

    patch toggle_hidden_admin_category_path(id: cat.slug)
    assert_response :found
    assert_redirected_to admin_categories_path
    cat.reload
    assert_not cat.hidden?
  end

  test 'admins can unhide a category via AJAX' do
    cat = create_persisted_category

    cat.hide!
    login(create_admin_user)

    patch toggle_hidden_admin_category_path(id: cat.slug), xhr: true
    assert_response :found
    assert_redirected_to admin_categories_path
    cat.reload
    assert_not cat.hidden?
  end
end
