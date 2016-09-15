require 'test_helper'

class CommentsIntegrationTest < ActionDispatch::IntegrationTest
  test 'an unauthenticated user access comments#create' do

  end

  test 'an authenticated user can comment on a post' do

  end

  # Voting
  test 'an unauthenticated user cannot access comments#vote' do

  end

  test 'an authenticated user can vote on a comment' do

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
