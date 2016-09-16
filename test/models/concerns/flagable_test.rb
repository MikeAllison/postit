require 'test_helper'

class FlagableTest < ActiveSupport::TestCase
  test 'self.flagged' do
    post1 = create_persisted_post
    post1.flags.create(flag: false)
    post1.save

    post2 = create_persisted_post(2, 2)
    post2.flags.create(flag: true)
    post2.save

    assert_not_includes Post.flagged, post1
    assert_includes Post.flagged, post2
  end

  test 'flagged_by?(user)' do
    user1 = create_standard_user
    user2 = create_standard_user(2)

    post = create_post_by_user(user1)

    post.flags.create(flag: true, user_id: user2.id)

    assert post.flagged_by?(user2)
    assert_not post.flagged_by?(user1)
  end

  test 'flagged?' do
    post1 = create_persisted_post
    post1.flags.create(flag: true)
    post1.save

    post2 = create_persisted_post(2, 2)
    post2.flags.create(flag: false)
    post2.save

    assert post1.flagged?
    assert_not post2.flagged?
  end

  test 'initialize_total_flags' do
    post = Post.new
    assert_equal 0, post.total_flags
  end

  test 'initialize_hidden_attr' do
    post = Post.new
    assert_not post.hidden
  end

  test 'scope :flagged' do
    post = create_persisted_post
    post.flags.create(flag: true, user_id: 1)
    assert_not Post.flagged.empty?

    flag1 = post.flags.first
    flag1.flag = false
    flag1.save
    assert Post.flagged.empty?

    post.flags.create(flag: true, user_id: 2)
    assert_not Post.flagged.empty?
  end

  test 'reset_total_flags' do
    # Post
    post = create_persisted_post

    2.times do |i|
      post.flags.create(flag: true, user_id: i+1)
    end

    post.reload
    post.reset_total_flags

    post.reload
    assert_equal 0, post.total_flags
  end
end
