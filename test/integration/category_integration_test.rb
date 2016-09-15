require 'test_helper'

class CategoryIntegrationTest < ActionDispatch::IntegrationTest
  test 'unauthenticated users can access categories#index via HTTP' do
    cat = create_persisted_category

    get category_path(id: cat.slug)

    assert_response :success
    assert assigns :category
  end

  test 'unauthenticated users can access categories#index via AJAX' do
    cat = create_persisted_category

    get category_path(id: cat.slug), xhr: true

    assert_response :success
    assert assigns :category
  end
end
