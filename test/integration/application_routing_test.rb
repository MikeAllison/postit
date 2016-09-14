class ApplicationRoutingTest < ActionDispatch::IntegrationTest
  test 'root route' do
    get root_path
    assert_response :success
    assert_generates "/", controller: :posts, action: :index
  end

  test 'catch_not_found' do
    get post_path('asdf 1234')
    assert_redirected_to root_path
    assert_equal "Sorry, the page that you are looking for doesn't exist.", flash[:warning]
  end

  test 'catch_routing_error' do
    get '/notarealroute'
    assert_redirected_to root_path
    assert_equal "Sorry, the page that you are looking for doesn't exist.", flash[:warning]
  end
end
