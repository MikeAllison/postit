require 'test_helper'

class CommentsIntegrationTest < ActionDispatch::IntegrationTest
  #
  # comments#create
  #
  test 'an unauthenticated user cannot access comments#create' do
    post = create_persisted_post

    assert_no_difference('Comment.count') do
      post post_comments_path(post_id: post.slug), { comment: { body: 'A comment.' } }
    end

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'an authenticated user can comment on a post' do
    post = create_persisted_post
    login(create_standard_user)

    assert_difference('Comment.count', 1) do
      post post_comments_path(post_id: post.slug), { comment: { body: 'A comment.' } }
    end

    assert_redirected_to post_path(id: post.slug)
    assert_equal 'Your comment was added.', flash[:success]
    post.reload
    assert_equal 1, post.unhidden_comments_count
  end

  test 'a comment cannot be added to a flagged post' do
    post = create_persisted_post
    post.flags.create(flag: true)
    post.save

    login(create_standard_user)

    assert_no_difference('Comment.count') do
      post post_comments_path(post_id: post.slug), { comment: { body: 'A comment.' } }
    end

    assert_redirected_to post_path(id: post.slug)
    assert_equal 'You may not comment on a post that has been flagged for review.', flash[:danger]
  end

  test 'an invalid comment' do
    post = create_persisted_post
    login(create_standard_user)

    assert_no_difference('Comment.count') do
      post post_comments_path(post_id: post.slug), { comment: { body: ' ' } }
    end

    assert_template :show
  end

  #
  # comments#vote
  #
  test 'an unauthenticated user cannot vote on a comment' do
    comment = create_persisted_comment

    # HTTP
    assert_no_difference('Comment.count') do
      post vote_comment_path(id: comment.id), { body: 'A comment.' }
    end

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]

    # AJAX
    assert_no_difference('Comment.count') do
      post vote_comment_path(id: comment.id), { body: 'A comment.' }, xhr: true
    end

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
    comment.flags.create(flag: true)

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

  test 'comment/vote only accepts true/false' do
    comment = create_persisted_comment
    login(create_standard_user)

    # HTTP
    post vote_comment_path(id: comment.id), { vote: 'invalidvote' }

    comment.reload
    assert_equal 0, comment.tallied_votes
    assert_equal "Sorry, there was a problem submitting your vote.  Please try again.", flash[:danger]

    # AJAX
    post vote_comment_path(id: comment.id), { vote: 'invalidvote' }, xhr: true

    comment.reload
    assert_equal 0, comment.tallied_votes
    assert_equal "Sorry, there was a problem submitting your vote.  Please try again.", flash[:danger]
  end

  #
  # comments/flag
  #
  test 'an unauthenticated user cannot access comments#flag' do
    comment = create_persisted_comment

    # HTTP
    assert_no_difference('Flag.count') do
      post flag_comment_path(id: comment.id), { flag: 'true' }
    end

    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]

    # AJAX
    assert_no_difference('Flag.count') do
      post flag_comment_path(id: comment.id), { flag: 'true' }, xhr: true
    end

    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'users cannot flag a comment' do
    comment = create_persisted_comment
    login(create_standard_user)

    # HTTP
    assert_no_difference('Flag.count') do
      post flag_comment_path(id: comment.id), { flag: 'true' }
    end

    assert_equal 'This action requires moderator, or administrator, rights.', flash[:danger]

    # AJAX
    assert_no_difference('Flag.count') do
      post flag_comment_path(id: comment.id), { flag: 'true' }, xhr: true
    end

    assert_equal 'This action requires moderator, or administrator, rights.', flash[:danger]
  end

  test 'moderators can flag a comment via HTTP' do
    comment = create_persisted_comment
    login(create_moderator_user)

    post flag_comment_path(id: comment.id), { flag: 'true' }

    comment.reload
    assert comment.flagged?
  end

  test 'moderators can flag a comment via AJAX' do
    comment = create_persisted_comment
    login(create_moderator_user)

    post flag_comment_path(id: comment.id), { flag: 'true' }, xhr: true

    comment.reload
    assert comment.flagged?
  end

  test 'admins can flag a comment via HTTP' do
    comment = create_persisted_comment
    login(create_admin_user)

    post flag_comment_path(id: comment.id), { flag: 'true' }

    comment.reload
    assert comment.flagged?
  end

  test 'admins can flag a comment via AJAX' do
    comment = create_persisted_comment
    login(create_admin_user)

    post flag_comment_path(id: comment.id), { flag: 'true' }, xhr: true

    comment.reload
    assert comment.flagged?
  end

  test 'users cannot unflag a comment' do
    comment = create_persisted_comment
    comment.flags.create(flag: true)

    login(create_standard_user)

    # HTTP
    post flag_comment_path(id: comment.id), { flag: 'false' }

    comment.reload
    assert comment.flagged?
    assert_equal 'This action requires moderator, or administrator, rights.', flash[:danger]

    # AJAX
    post flag_comment_path(id: comment.id), { flag: 'false' }, xhr: true

    comment.reload
    assert comment.flagged?
    assert_equal 'This action requires moderator, or administrator, rights.', flash[:danger]
  end

  test 'moderators can unflag their own flag on a comment' do
    comment = create_persisted_comment
    moder = login(create_moderator_user)

    # HTTP
    post flag_comment_path(id: comment.id), { flag: 'true' }
    post flag_comment_path(id: comment.id), { flag: 'false' }

    comment.reload
    assert_equal false, comment.flags.find_by(user_id: moder.id).flag

    # AJAX
    post flag_comment_path(id: comment.id), { flag: 'true' }, xhr: true
    post flag_comment_path(id: comment.id), { flag: 'false' }, xhr: true

    comment.reload
    assert_equal false, comment.flags.find_by(user_id: moder.id).flag
  end

  test 'moderators cannot unflag a flag from another moderator' do
    comment = create_persisted_comment
    moder1 = login(create_moderator_user)

    post flag_comment_path(id: comment.id), { flag: 'true' }
    logout!

    login(create_moderator_user(2))

    # HTTP
    post flag_comment_path(id: comment.id), { flag: 'false' }

    comment.reload
    assert_equal true, comment.flags.find_by(user_id: moder1.id).flag

    # AJAX
    post flag_comment_path(id: comment.id), { flag: 'false' }, xhr: true

    comment.reload
    assert_equal true, comment.flags.find_by(user_id: moder1.id).flag
  end

  test 'admins can unflag their own flag on a comment' do
    comment = create_persisted_comment
    admin = login(create_admin_user)

    # HTTP
    post flag_comment_path(id: comment.id), { flag: 'true' }
    post flag_comment_path(id: comment.id), { flag: 'false' }

    comment.reload
    assert_equal false, comment.flags.find_by(user_id: admin.id).flag

    # AJAX
    post flag_comment_path(id: comment.id), { flag: 'true' }, xhr: true
    post flag_comment_path(id: comment.id), { flag: 'false' }, xhr: true

    comment.reload
    assert_equal false, comment.flags.find_by(user_id: admin.id).flag
  end

  test 'admins cannot unflag a flag from another user' do
    comment = create_persisted_comment
    moder = login(create_moderator_user)

    post flag_comment_path(id: comment.id), { flag: 'true' }
    logout!

    login(create_admin_user)

    # HTTP
    post flag_comment_path(id: comment.id), { flag: 'false' }

    comment.reload
    assert_equal true, comment.flags.find_by(user_id: moder.id).flag

    # AJAX
    post flag_comment_path(id: comment.id), { flag: 'false' }, xhr: true

    comment.reload
    assert_equal true, comment.flags.find_by(user_id: moder.id).flag
  end

  test 'comments/flag only accepts true/false' do
    comment = create_persisted_comment

    login(create_moderator_user)

    # HTTP
    post flag_comment_path(id: comment.id), { flag: 'true' }
    post flag_comment_path(id: comment.id), { flag: 'nottrueorfalse' }

    comment.reload
    assert comment.flagged?
    assert_equal "Sorry, there was a problem submitting your flag.  Please try again.", flash[:danger]

    # AJAX
    post flag_comment_path(id: comment.id), { flag: 'true' }, xhr: true
    post flag_comment_path(id: comment.id), { flag: 'nottrueorfalse' }, xhr: true

    comment.reload
    assert comment.flagged?
    assert_equal "Sorry, there was a problem submitting your flag.  Please try again.", flash[:danger]
  end

  #
  # comments/clear_flags
  #
  test 'an unauthenticated user cannot access comments#clear_flags' do
    comment = create_persisted_comment
    comment.flags.create(flag: true)
    comment.reload

    # HTTP
    assert_no_difference('Flag.all.count') do
      patch clear_flags_comment_path(id: comment.id)
    end

    comment.reload
    assert comment.flagged?
    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]

    # AJAX
    assert_no_difference('Flag.all.count') do
      patch clear_flags_comment_path(id: comment.id), xhr: true
    end

    comment.reload
    assert comment.flagged?
    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'users cannot clear all flags on a comment' do
    comment = create_persisted_comment
    comment.flags.create(flag: true)
    comment.reload

    login(create_standard_user)

    # HTTP
    assert_no_difference('Flag.all.count') do
      patch clear_flags_comment_path(id: comment.id)
    end

    comment.reload
    assert comment.flagged?
    assert_equal 'This action requires administrator rights.', flash[:danger]

    # AJAX
    assert_no_difference('Flag.all.count') do
      patch clear_flags_comment_path(id: comment.id), xhr: true
    end

    comment.reload
    assert comment.flagged?
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'moderators cannot clear all flags on a comment' do
    comment = create_persisted_comment
    comment.flags.create(flag: true)
    comment.reload

    login(create_moderator_user)

    # HTTP
    assert_no_difference('Flag.all.count') do
      patch clear_flags_comment_path(id: comment.id)
    end

    comment.reload
    assert comment.flagged?
    assert_equal 'This action requires administrator rights.', flash[:danger]

    # AJAX
    assert_no_difference('Flag.all.count') do
      patch clear_flags_comment_path(id: comment.id), xhr: true
    end
    
    comment.reload
    assert comment.flagged?
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'admins can clear all flags on a comment via HTTP' do
    comment = create_persisted_comment
    2.times do |i|
      comment.flags.create(flag: true, user_id: i + 2)
    end
    comment.reload

    login(create_admin_user)

    # HTTP
    assert_difference('Flag.all.count', -2) do
      patch clear_flags_comment_path(id: comment.id)
    end

    comment.reload
    assert_not comment.flagged?
    assert_equal 0, comment.total_flags
  end

  test 'admins can clear all flags on a comment via AJAX' do
    comment = create_persisted_comment
    2.times do |i|
      comment.flags.create(flag: true, user_id: i + 2)
    end
    comment.reload

    login(create_admin_user)

    assert_difference('Flag.all.count', -2) do
      patch clear_flags_comment_path(id: comment.id), xhr: true
    end

    comment.reload
    assert_not comment.flagged?
    assert_equal 0, comment.total_flags
  end

  #
  # comments/hide
  #
  test 'an unauthenticated user cannot access comments#hide' do
    comment = create_persisted_comment

    # HTTP
    patch hide_comment_path(id: comment.id), { hidden: true }

    comment.reload
    assert_not comment.hidden?
    assert_redirected_to login_path
    assert_equal 'You must log in to access that page.', flash[:danger]

    # AJAX
    patch hide_comment_path(id: comment.id), { hidden: true }, xhr: true

    comment.reload
    assert_not comment.hidden?
    assert_equal 'You must log in to access that page.', flash[:danger]
  end

  test 'a user cannot hide a comment' do
    comment = create_persisted_comment
    login(create_standard_user)

    # HTTP
    patch hide_comment_path(id: comment.id), { hidden: true }

    comment.reload
    assert_not comment.hidden?
    assert_equal 'This action requires administrator rights.', flash[:danger]

    # AJAX
    patch hide_comment_path(id: comment.id), { hidden: true }, xhr: true

    comment.reload
    assert_not comment.hidden?
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'a moderator cannot hide a comment' do
    comment = create_persisted_comment
    login(create_moderator_user)

    # HTTP
    patch hide_comment_path(id: comment.id), { hidden: true }

    comment.reload
    assert_not comment.hidden?
    assert_equal 'This action requires administrator rights.', flash[:danger]

    # AJAX
    patch hide_comment_path(id: comment.id), { hidden: true }, xhr: true

    comment.reload
    assert_not comment.hidden?
    assert_equal 'This action requires administrator rights.', flash[:danger]
  end

  test 'an admin can hide a comment' do
    post = create_persisted_post
    comment1 = post.comments.create(body: 'Comment 1')
    comment2 = post.comments.create(body: 'Comment 2')
    2.times { post.increase_unhidden_comments_count }

    login(create_admin_user)

    # HTTP
    patch hide_comment_path(id: comment1.id), { hidden: true }

    comment1.reload
    assert comment1.hidden?
    post.reload
    assert_equal 1, post.unhidden_comments_count

    # AJAX
    patch hide_comment_path(id: comment2.id), { hidden: true }, xhr: true

    comment2.reload
    assert comment2.hidden?
    post.reload
    assert_equal 0, post.unhidden_comments_count
  end
end
