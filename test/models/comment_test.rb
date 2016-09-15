require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'can add a valid comment' do
    comm = create_persisted_comment

    assert comm.persisted?
  end

  test 'cannot save a comment without a body' do
    comm = Comment.create(body: '')
    assert_not comm.persisted?

    assert_equal 'Comment cannot be blank', comm.errors.messages[:body].first
  end

  test 'initialize_tallied_votes' do
    comm = Comment.new

    assert_equal 0, comm.tallied_votes
  end

  test 'clear_flags' do
    comm = create_persisted_comment
    2.times do
      comm.flags.create
    end
    comm.clear_flags

    assert_equal 0, comm.flags.count
    assert_equal 0, comm.total_flags
  end

  test 'hide' do
    post = create_persisted_post

    comm = post.comments.create(body: 'A valid comment')
    2.times do
      comm.flags.create
      comm.votes.create
    end
    comm.hide

    assert comm.hidden
    assert_equal 0, comm.flags.count
    assert_equal 0, comm.votes.count
    assert_equal(-1, comm.post.unhidden_comments_count)
  end
end
