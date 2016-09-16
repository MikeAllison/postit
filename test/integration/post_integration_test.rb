require 'test_helper'

class PostIntegrationTest < ActionDispatch::IntegrationTest
  #
  # posts#index
  #
  test 'an unauthenticated user can access posts#index' do
    get posts_path
    assert_response :success
    assert assigns :posts

    get posts_path, xhr: true
    assert_response :success
    assert assigns :posts
  end

  #
  # posts#new
  #
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

  #
  # posts#create
  #
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

  #
  # posts#show
  #
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

  #
  # posts#edit
  #
  test 'an unauthenticated user cannot access posts#edit' do
    get edit_post_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user cannot edit a post from another user' do
    user = login(create_standard_user)
    post = create_post_by_user(user)

    login(create_standard_user(2))

    get edit_post_path(id: post.slug)

    assert_redirected_to post_path(id: post.slug)
    assert_equal "Access Denied! - You may only edit posts that you've created.", flash[:danger]
  end

  test 'an authenticated user can edit their own post' do
    user = login(create_standard_user)
    post = create_post_by_user(user)

    get edit_post_path(id: post.slug)

    assert_response :success
    assert assigns :post
  end

  test 'a moderator cannot edit another users post' do
    user = login(create_standard_user)
    post = create_post_by_user(user)

    login(create_moderator_user)

    get edit_post_path(id: post.slug)

    assert_redirected_to post_path(id: post.slug)
    assert_equal "Access Denied! - You may only edit posts that you've created.", flash[:danger]
  end

  test 'an admin can edit another users post' do
    user = login(create_standard_user)
    login(create_admin_user)

    post = create_post_by_user(user)

    get edit_post_path(id: post.slug)

    assert_response :success
    assert assigns :post
  end

  #
  # posts#update
  #
  test 'an unauthenticated user cannot access posts#update via PATCH' do
    post = create_persisted_post

    assert_no_difference('post.description.length') do
      patch post_path(id: post.slug), post: { description: 'changed' }
    end

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an unauthenticated user cannot access posts#update via PUT' do
    post = create_persisted_post

    assert_no_difference('post.description.length') do
      put post_path(id: post.slug), post: { description: 'changed' }
    end

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user cannot update a post from another user via PATCH' do
    user = create_standard_user
    post = create_post_by_user(user)

    login(create_standard_user(2))

    assert_no_difference('post.description.length') do
      patch post_path(id: post.slug), post: { description: 'changed' }
    end

    assert_redirected_to post_path(id: post.slug)
    assert_equal "Access Denied! - You may only edit posts that you've created.", flash[:danger]
  end

  test 'an authenticated user cannot update a post from another user via PUT' do
    user = create_standard_user
    post = create_post_by_user(user)

    login(create_standard_user(2))

    assert_no_difference('post.description.length') do
      put post_path(id: post.slug), post: { description: 'changed' }
    end

    assert_redirected_to post_path(id: post.slug)
    assert_equal "Access Denied! - You may only edit posts that you've created.", flash[:danger]
  end

  test 'an authenticated user can update their own post via PATCH' do
    user = login(create_standard_user)
    post = create_post_by_user(user)

    patch post_path(id: post.slug), { post: {
      title: 'New Title',
      url: 'http://www.newurl.com',
      description: 'A new description'
    } }

    post.reload
    assert_equal 'New Title', post.title
    assert_equal 'http://www.newurl.com', post.url
    assert_equal 'A new description', post.description
    assert_redirected_to post_path(id: post.slug)
    assert_equal 'Your post was updated.', flash[:success]
  end

  test 'an authenticated user can update their own post via PUT' do
    user = login(create_standard_user)
    post = create_post_by_user(user)

    put post_path(id: post.slug), { post: {
      title: 'New Title',
      url: 'http://www.newurl.com',
      description: 'A new description'
    } }

    post.reload
    assert_equal 'New Title', post.title
    assert_equal 'http://www.newurl.com', post.url
    assert_equal 'A new description', post.description
    assert_redirected_to post_path(id: post.slug)
    assert_equal 'Your post was updated.', flash[:success]
  end

  test 'a moderator cannot update another users post via PATCH' do
    user = create_standard_user
    post = create_post_by_user(user)
    login(create_moderator_user)

    patch post_path(id: post.slug), { post: {
      title: 'New Title',
      url: 'http://www.newurl.com',
      description: 'A new description'
    } }

    assert_redirected_to post_path(id: post.slug)
    assert_equal "Access Denied! - You may only edit posts that you've created.", flash[:danger]
  end

  test 'a moderator cannot update another users post via PUT' do
    user = create_standard_user
    post = create_post_by_user(user)
    login(create_moderator_user)

    put post_path(id: post.slug), { post: {
      title: 'New Title',
      url: 'http://www.newurl.com',
      description: 'A new description'
    } }
  end

  test 'an admin can update another users post via PATCH' do
    user = create_standard_user
    post = create_post_by_user(user)
    login(create_admin_user)

    patch post_path(id: post.slug), { post: {
      title: 'New Title',
      url: 'http://www.newurl.com',
      description: 'A new description'
    } }

    post.reload
    assert_equal 'New Title', post.title
    assert_equal 'http://www.newurl.com', post.url
    assert_equal 'A new description', post.description
    assert_redirected_to post_path(id: post.slug)
    assert_equal 'Your post was updated.', flash[:success]
  end

  test 'an admin can update another users post via PUT' do
    user = create_standard_user
    post = create_post_by_user(user)
    login(create_admin_user)

    put post_path(id: post.slug), { post: {
      title: 'New Title',
      url: 'http://www.newurl.com',
      description: 'A new description'
    } }

    post.reload
    assert_equal 'New Title', post.title
    assert_equal 'http://www.newurl.com', post.url
    assert_equal 'A new description', post.description
    assert_redirected_to post_path(id: post.slug)
    assert_equal 'Your post was updated.', flash[:success]
  end

  test 'a failed post update via PATCH' do
    user = login(create_standard_user)
    post = create_post_by_user(user)

    patch post_path(id: post.slug), { post: {
      title: ''
    } }

    assert_template :edit
  end

  test 'a failed post update via PUT' do
    user = login(create_standard_user)
    post = create_post_by_user(user)

    put post_path(id: post.slug), { post: {
      title: ''
    } }

    assert_template :edit
  end

  #
  # posts#vote
  #
  test 'an unauthenticated user cannot vote on a post' do
    post = create_persisted_post

    # HTTP
    assert_no_difference('Vote.count') do
      post vote_post_path(id: post.slug), { vote: 'true' }
    end

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]

    # AJAX
    assert_no_difference('Vote.count') do
      post vote_post_path(id: post.slug), { vote: 'true' }, xhr: true
    end

    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user can upvote a post via HTTP' do
    post = create_persisted_post
    login(create_standard_user)

    post vote_post_path(id: post.slug), { vote: 'true' }

    post.reload
    assert_equal 1, post.tallied_votes
  end

  test 'an authenticated user can upvote a post via AJAX' do
    post = create_persisted_post
    login(create_standard_user)

    post vote_post_path(id: post.slug), { vote: 'true' }, xhr: true

    post.reload
    assert_equal 1, post.tallied_votes
  end

  test 'an authenticated user can downvote a post via HTTP' do
    post = create_persisted_post
    login(create_standard_user)

    post vote_post_path(id: post.slug), { vote: 'false' }

    post.reload
    assert_equal(-1, post.tallied_votes)
  end

  test 'an authenticated user can downvote a post via AJAX' do
    post = create_persisted_post
    login(create_standard_user)

    post vote_post_path(id: post.slug), { vote: 'false' }, xhr: true

    post.reload
    assert_equal(-1, post.tallied_votes)
  end

  test 'an authenticated user cannot vote on a flagged post' do
    login(create_standard_user)

    post = create_persisted_post
    post.flags.create(flag: true)

    post vote_post_path(id: post.slug), { vote: 'true' }

    post.reload
    assert_equal 0, post.tallied_votes
    assert_equal 'You may not vote on a post that has been flagged for review.', flash[:danger]
  end

  test 'a user cannot vote on a post more than once' do
    post = create_persisted_post
    login(create_standard_user)

    post vote_post_path(id: post.slug), { vote: 'true' }

    post.reload
    assert_equal 1, post.tallied_votes

    post vote_post_path(id: post.slug), { vote: 'true' }
    assert_equal "You've already voted on this post.", flash[:danger]
  end

  test 'a user can change their vote' do
    post = create_persisted_post
    login(create_standard_user)

    post vote_post_path(id: post.slug), { vote: 'true' }

    post.reload
    assert_equal 1, post.tallied_votes

    post vote_post_path(id: post.slug), { vote: 'false' }
    post vote_post_path(id: post.slug), { vote: 'false' }

    post.reload
    assert_equal(-1, post.tallied_votes)
  end

  test 'a vote on a post must be true/false' do
    post = create_persisted_post
    login(create_standard_user)

    post vote_post_path(id: post.slug), { vote: 'invalidvote' }

    post.reload
    assert_equal 0, post.tallied_votes
    assert_equal "Sorry, your vote couldn't be counted.", flash[:danger]
  end

  #
  # post#flag
  #
  test 'an unauthenticated user cannot access post#flag' do
    post = create_persisted_post

    # HTTP
    assert_no_difference('Flag.count') do
      post flag_post_path(id: post.slug), { flag: 'true' }
    end

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]

    # AJAX
    assert_no_difference('Flag.count') do
      post flag_post_path(id: post.slug), { flag: 'true' }, xhr: true
    end

    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'users cannot flag a post' do
    post = create_persisted_post
    login(create_standard_user)

    # HTTP
    assert_no_difference('Flag.count') do
      post flag_post_path(id: post.slug), { flag: 'true' }
    end

    assert_equal 'This action requires moderator, or administrator, rights.', flash[:danger]

    # AJAX
    assert_no_difference('Flag.count') do
      post flag_post_path(id: post.slug), { flag: 'true' }, xhr: true
    end

    assert_equal 'This action requires moderator, or administrator, rights.', flash[:danger]
  end

  test 'moderators can flag a post via HTTP' do
    post = create_persisted_post
    login(create_moderator_user)

    post flag_post_path(id: post.slug), { flag: 'true' }

    post.reload
    assert post.flagged?
  end

  test 'moderators can flag a post via AJAX' do
    post = create_persisted_post
    login(create_moderator_user)

    post flag_post_path(id: post.slug), { flag: 'true' }, xhr: true

    post.reload
    assert post.flagged?
  end

  test 'admins can flag a post via HTTP' do
    post = create_persisted_post
    login(create_admin_user)

    post flag_post_path(id: post.slug), { flag: 'true' }

    post.reload
    assert post.flagged?
  end

  test 'admins can flag a post via AJAX' do
    post = create_persisted_post
    login(create_admin_user)

    post flag_post_path(id: post.slug), { flag: 'true' }, xhr: true

    post.reload
    assert post.flagged?
  end

  test 'users cannot unflag a post' do
    post = create_persisted_post
    post.flags.create(flag: true)

    login(create_standard_user)

    post flag_comment_path(id: post.slug), { flag: 'false' }, xhr: true

    post.reload
    assert post.flagged?
    assert_equal 'This action requires moderator, or administrator, rights.', flash[:danger]
  end

  #
  # Misc
  #
  test 'a category must exist before adding a post' do
    login(create_admin_user)

    get new_post_path

    assert_redirected_to new_admin_category_path
    assert_equal 'Please add a category before creating a post.', flash[:danger]
  end
end
