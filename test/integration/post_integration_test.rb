require 'test_helper'

class PostIntegrationTest < ActionDispatch::IntegrationTest
  # posts#index
  test 'an unauthenticated user can access posts#index' do
    create_valid_post

    get posts_path
    assert_response :success
    assert assigns :posts

    get posts_path, xhr: true
    assert_response :success
    assert assigns :posts
  end

  # posts#show
  test 'an unauthenticated user can access posts#show' do
    p = create_valid_post

    get post_path(id: p.slug)

    assert_response :success
    assert assigns :post
  end

  # posts/new
  test 'an unauthenticated in user cannot access the new post page' do
    get new_post_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  # posts/create
  test 'an unauthenticated user cannot make a post' do
    assert_no_difference('Post.count') do
      post posts_path, { post: {
        title: 'Post 1',
        url: 'http://www.example.com',
        description: 'A cool post.',
        category_ids: [1]
      } }
    end

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'a authenticated user can make a post' do
    c = create_valid_category
    u = create_standard_user
    log_in_standard_user

    assert_difference('Post.count') do
      post posts_path, { post: {
        title: 'Post 1',
        url: 'http://www.example.com',
        description: 'A cool post.',
        category_ids: [c.id]
      } }
    end

    assert_equal Post.last.id, u.id
    assert_redirected_to posts_path
    assert_equal 'Your post was created.', flash[:success]
  end

  # posts/new
  test 'an authenticated user can access the new post page' do
    create_valid_category
    create_standard_user
    log_in_standard_user

    get new_post_path

    assert_response :success
    assert_generates '/posts/new', controller: :posts, action: :new
  end

  # posts/edit

  # Misc
  test 'a category must exist before adding a post' do
    create_admin_user
    log_in_admin_user

    get new_post_path

    assert_redirected_to new_admin_category_path
    assert_equal 'Please add a category before creating a post.', flash[:danger]
  end
end
