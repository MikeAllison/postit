require 'test_helper'

class CategoryIntegrationTest < ActionDispatch::IntegrationTest
  test 'unauthenticated users can access categories#index via HTTP' do
    c = create_persisted_category

    get category_path(id: c.slug)

    assert_response :success
    assert assigns :category
  end

  test 'unauthenticated users can access categories#index via AJAX' do
    c = create_persisted_category

    get category_path(id: c.slug), xhr: true

    assert_response :success
    assert assigns :category
  end
end
