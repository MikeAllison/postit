require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'can add a valid comment' do
    c = create_valid_comment
    assert c.persisted?
  end

  test 'cannot save a comment without a body' do
    c = Comment.create(body: '')
    assert_not c.persisted?
    assert_equal 'Comment cannot be blank', c.errors.messages[:body].first
  end

  test 'initialize_tallied_votes' do
    c = Comment.new
    assert_equal 0, c.tallied_votes
  end

  test 'clear_flags' do
    c = create_valid_comment
    2.times do
      c.flags.create
    end
    c.clear_flags
    assert_equal 0, c.flags.count
    assert_equal 0, c.total_flags
  end

  test 'hide' do
    p = create_valid_post
    c = p.comments.create(body: 'A valid comment')
    2.times do
      c.flags.create
      c.votes.create
    end
    c.hide
    assert c.hidden
    assert_equal 0, c.flags.count
    assert_equal 0, c.votes.count
    assert_equal -1, c.post.unhidden_comments_count
  end
end
