require 'test_helper'

class PostIntegrationTest < ActionDispatch::IntegrationTest
  # posts#index
  test 'an unauthenticated user can access posts#index' do
    create_persisted_post

    get posts_path
    assert_response :success
    assert assigns :posts

    get posts_path, xhr: true
    assert_response :success
    assert assigns :posts
  end

  # posts#new
  test 'an unauthenticated in user cannot access the new post page' do
    get new_post_path

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user can access the new post page' do
    create_persisted_category

    login(create_standard_user)

    get new_post_path

    assert_response :success
    assert_generates '/posts/new', controller: :posts, action: :new
  end

  # posts#create
  test 'an unauthenticated user cannot create a post' do
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

  test 'a authenticated user can create a post' do
    cat = create_persisted_category
    user = login(create_standard_user)

    assert_difference('Post.count') do
      post posts_path, { post: {
        title: 'Post 1',
        url: 'http://www.example.com',
        description: 'A cool post.',
        category_ids: [cat.id]
      } }
    end

    assert_equal Post.last.id, user.id
    assert_redirected_to posts_path
    assert_equal 'Your post was created.', flash[:success]
  end

  # posts#show
  test 'an unauthenticated user can access posts#show' do
    post = create_persisted_post

    get post_path(id: post.slug)

    assert_response :success
    assert assigns :post
  end

  test 'an authenticated user can access posts#show' do
    post = create_persisted_post

    login(create_standard_user)

    get post_path(id: post.slug)

    assert_response :success
    assert assigns :post
  end

  # posts#edit
  test 'an unauthenticated user cannot access posts#edit' do
    get edit_post_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user cannot edit a post from another user' do
    user = login(create_standard_user)
    post = create_post_by(user)

    login(create_standard_user2)

    get edit_post_path(id: post.slug)

    assert_redirected_to post_path(id: post.slug)
    assert_equal "Access Denied! - You may only edit posts that you've created.", flash[:danger]
  end

  test 'an authenticated user can edit their own post' do
    user = login(create_standard_user)
    post = create_post_by(user)

    get edit_post_path(id: post.slug)

    assert_response :success
    assert assigns :post
  end

  test 'a moderator cannot edit another users post' do
    user = login(create_standard_user)
    post = create_post_by(user)

    login(create_moderator_user)

    get edit_post_path(id: post.slug)

    assert_redirected_to post_path(id: post.slug)
    assert_equal "Access Denied! - You may only edit posts that you've created.", flash[:danger]
  end

  test 'an admin can edit another users post' do
    user = login(create_standard_user)
    login(create_admin_user)

    post = create_post_by(user)

    get edit_post_path(id: post.slug)

    assert_response :success
    assert assigns :post
  end

  # posts#update
  test 'an unauthenticated user cannot access posts#update via PATCH' do
    patch post_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an unauthenticated user cannot access posts#update via PUT' do
    put post_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user cannot update a post from another user via PATCH' do
    user = create_standard_user
    post = create_post_by(user)

    login(create_standard_user2)

    patch post_path(id: post.slug)

    assert_redirected_to post_path(id: post.slug)
    assert_equal "Access Denied! - You may only edit posts that you've created.", flash[:danger]
  end

  test 'an authenticated user cannot update a post from another user via PUT' do
    user = create_standard_user
    post = create_post_by(user)

    login(create_standard_user2)

    put post_path(id: post.slug)

    assert_redirected_to post_path(id: post.slug)
    assert_equal "Access Denied! - You may only edit posts that you've created.", flash[:danger]
  end

  test 'an authenticated user can update their own post via PATCH' do

  end

  test 'an authenticated user can update their own post via PUT' do

  end

  test 'a moderator cannot update another users post via PATCH' do

  end

  test 'a moderator cannot update another users post via PUT' do

  end

  test 'an admin can update another users post via PATCH' do

  end

  test 'an admin can update another users post via PUT' do

  end

  # Misc
  test 'a category must exist before adding a post' do
    login(create_admin_user)

    get new_post_path

    assert_redirected_to new_admin_category_path
    assert_equal 'Please add a category before creating a post.', flash[:danger]
  end
end
