require 'test_helper'

class CommentsIntegrationTest < ActionDispatch::IntegrationTest
  # comments#create
  test 'an unauthenticated user cannot access comments#create' do
    post post_comments_path(post_id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user can comment on a post' do
    post = create_persisted_post
    login(create_standard_user)

    assert_difference('Comment.count') do
      post post_comments_path(post_id: post.slug), { comment: { body: 'A comment.' } }
    end

    assert_redirected_to post_path(id: post.slug)
    assert_equal 'Your comment was added.', flash[:success]
  end

  test 'an invalid comment' do
    post = create_persisted_post
    login(create_standard_user)

    assert_no_difference('Comment.count') do
      post post_comments_path(post_id: post.slug), { comment: { body: ' ' } }
    end

    assert_template :show
  end

  # comments#vote
  test 'an unauthenticated user cannot vote on a comment' do
    # HTTP
    post vote_comment_path(id: 1)

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]

    # AJAX
    post vote_comment_path(id: 1), xhr: true

    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user can upvote a comment via HTTP' do
    comment = create_persisted_comment
    login(create_standard_user)

    post vote_comment_path(id: comment.id), { vote: 'true' }

    comment.reload
    assert_equal 1, comment.tallied_votes
  end

  test 'an authenticated user can upvote a comment via AJAX' do
    comment = create_persisted_comment
    login(create_standard_user)

    post vote_comment_path(id: comment.id), { vote: 'true' }, xhr: true

    comment.reload
    assert_equal 1, comment.tallied_votes
  end

  test 'an authenticated user can downvote a comment via HTTP' do
    comment = create_persisted_comment
    login(create_standard_user)

    post vote_comment_path(id: comment.id), { vote: 'false' }

    comment.reload
    assert_equal(-1, comment.tallied_votes)
  end

  test 'an authenticated user can downvote a comment via AJAX' do
    comment = create_persisted_comment
    login(create_standard_user)

    post vote_comment_path(id: comment.id), { vote: 'false' }, xhr: true

    comment.reload
    assert_equal(-1, comment.tallied_votes)
  end

  test 'an authenticated user cannot vote on a flagged comment' do
    login(create_standard_user)

    comment = create_persisted_comment
    comment.total_flags = 1
    comment.save

    post vote_comment_path(id: comment.id), { vote: 'true' }

    comment.reload
    assert_equal 0, comment.tallied_votes
    assert_equal 'You may not vote on a comment that has been flagged for review.', flash[:danger]
  end

  test 'a user cannot vote on a comment more than once' do
    comment = create_persisted_comment
    login(create_standard_user)

    post vote_comment_path(id: comment.id), { vote: 'true' }

    comment.reload
    assert_equal 1, comment.tallied_votes

    post vote_comment_path(id: comment.id), { vote: 'true' }
    assert_equal "You've already voted on this comment.", flash[:danger]
  end

  test 'a user can change their vote' do
    comment = create_persisted_comment
    login(create_standard_user)

    post vote_comment_path(id: comment.id), { vote: 'true' }

    comment.reload
    assert_equal 1, comment.tallied_votes

    post vote_comment_path(id: comment.id), { vote: 'false' }
    post vote_comment_path(id: comment.id), { vote: 'false' }

    comment.reload
    assert_equal(-1, comment.tallied_votes)
  end

  test 'a vote on a comment must be true/false' do
    comment = create_persisted_comment
    login(create_standard_user)

    post vote_comment_path(id: comment.id), { vote: 'invalidvote' }

    comment.reload
    assert_equal 0, comment.tallied_votes
    assert_equal "Sorry, your vote couldn't be counted.", flash[:danger]
  end

  # Flagging
  test 'an unauthenticated user cannot access comments#flag' do

  end

  test 'a comment cannot be added to a flagged post' do

  end

  test 'a flagged comment cannot be voted on' do

  end

  test 'users cannot flag a comment' do

  end

  test 'moderators can flag a comment' do

  end

  test 'admins can flag a comment' do

  end

  test 'users cannot unflag a comment' do

  end

  test 'moderators can clear their own flag on a comment' do

  end

  test 'moderators cannot clear a flag from another moderator' do

  end

  test 'admins can clear their own flag on a comment' do

  end

  test 'admins cannot clear a flag from another user' do

  end

  test 'an unauthenticated user cannot access comments#clear_flags' do

  end

  test 'users cannot clear all flags on a comment' do

  end

  test 'moderators cannot clear all flags on a comment' do

  end

  test 'admins can clear all flags on a comment' do

  end

  # Hiding
  test 'an unauthenticated user cannot access comments#hide' do

  end

  test 'a user cannot hide a comment' do

  end

  test 'a moderator cannot hide a comment' do

  end

  test 'an admin can hide a comment' do

  end
end
