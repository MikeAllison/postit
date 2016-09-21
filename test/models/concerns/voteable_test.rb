require 'test_helper'

class VoteableTest < ActiveSupport::TestCase
  test 'vote_exists?' do
    user1 = create_standard_user(1)
    user2 = create_standard_user(2)
    post = create_persisted_post
    post.votes.create(vote: true, user_id: user1.id)

    assert post.vote_exists?(user1, true)
    assert_not post.vote_exists?(user1, false)
    assert_not post.vote_exists?(user2, true)
    assert_not post.vote_exists?(user2, false)
  end

  test 'calculate_tallied_votes' do
    post = create_persisted_post
    2.times { post.votes.create(vote: true) }
    3.times { post.votes.create(vote: false) }

    post.calculate_tallied_votes
    assert_equal(-1, post.tallied_votes)
  end

  test 'initialize_tallied_votes' do
    post = Post.new

    assert_equal 0, post.tallied_votes
  end

  test 'upvotes' do
    post = create_persisted_post
    2.times { post.votes.create(vote: true) }
    3.times { post.votes.create(vote: false) }

    assert_equal 2, post.send(:upvotes)
  end

  test 'downvotes' do
    post = create_persisted_post
    2.times { post.votes.create(vote: true) }
    3.times { post.votes.create(vote: false) }

    assert_equal 3, post.send(:downvotes)
  end
end
