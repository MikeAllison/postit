class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'destroy_session_if_user_disabled' do
    u = User.create(username: 'auser', password: 'password', time_zone: 'Eastern Time (US & Canada)')

    post login_path, { username: 'auser', password: 'password' }
    assert_redirected_to posts_path

    u.disabled = true
    u.save

    get new_post_path
    assert_redirected_to login_path
    assert_equal nil, session[:current_user_id]
    assert_equal 'Your account has been disabled.', flash[:danger]
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
