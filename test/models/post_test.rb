require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'can create a valid post' do
    post = create_persisted_post


    assert post.persisted?
  end

  test 'cannot save without a title' do
    post = create_persisted_post

    post.title = ''

    assert_not post.save
    assert_equal "Title field can't be blank", post.errors.messages[:title].first
  end

  test 'cannot save with a title < 2 characters' do
    post = create_persisted_post

    post.title = 'A'

    assert_not post.save
    assert_equal 'Title is too short (minimum is 2 characters)', post.errors.messages[:title].first
  end

  test 'cannot save without a url' do
    post = create_persisted_post

    post.url = ''

    assert_not post.save
    assert_equal "URL field can't be blank", post.errors.messages[:url].first
  end

  test 'cannot save a duplicate URL' do
    create_persisted_post

    post2 = Post.new(title: 'Valid Title 2',
                 url: 'http://www.url.com',
                 description: 'A valid description 2')
    post2.categories << Category.create(name: 'News')
    post2.save

    assert_not post2.persisted?
    assert_equal 'This URL has already been posted', post2.errors.messages[:url].first
  end

  test 'cannot save an invalid url' do
    post = create_persisted_post

    post.url = 'www.abc.com'

    assert_not post.save
    assert_equal 'URL field must be a valid URL (ex. http://www.example.com)', post.errors.messages[:url].first
  end

  test 'cannot save without a description' do
    post = create_persisted_post

    post.description = ''

    assert_not post.save
    assert_equal "Description field can't be blank", post.errors.messages[:description].first
  end

  test 'cannot save a post without a category' do
    post = Post.create(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: 'A valid description')

    assert_not post.persisted?
    assert_equal 'Please select at least one category', post.errors.messages[:categories].first
  end

  test 'initialize_unhidden_comments_count' do
    post = Post.new

    assert_equal 0, post.unhidden_comments_count
  end

  test 'initialize_tallied_votes' do
    post = Post.new

    assert_equal 0, post.tallied_votes
  end

  test 'strip_url_whitespace' do
    post = create_persisted_post

    post.url = ' http://www.a  bc.com  '

    assert post.save
    assert_equal 'http://www.abc.com', post.url
  end

  test 'downcase_url' do
    post = create_persisted_post

    post.url = 'hTTP://wWw.ABc.cOM'
    post.save

    assert post.persisted?
    assert_equal 'http://www.abc.com', post.url
  end

  test 'clear_flags' do
    post = create_persisted_post


    2.times do
      post.flags.create
    end
    post.clear_flags

    assert_equal 0, post.flags.count
    assert_equal 0, post.total_flags
  end

  test 'hide' do
    post = create_persisted_post


    2.times do
      post.votes.create
      post.flags.create
      post.comments.create(body: 'A valid comment')
      2.times do
        post.comments.each do |comment|
          comment.votes.create
          comment.flags.create
        end
      end
    end

    post.hide
    post.reload

    assert post.hidden
    assert_equal 0, post.votes.count
    assert_equal 0, post.flags.count

    post.comments.unscope(where: :hidden).each do |comment|
      assert_equal 0, comment.votes.count
      assert_equal 0, comment.flags.count
      assert comment.hidden
    end

    post.categories.each do |category|
      assert_equal(-1, category.unhidden_posts_count)
    end
  end

  test 'increase_unhidden_comments_count' do
    post = create_persisted_post

    post.increase_unhidden_comments_count

    assert_equal 1, post.unhidden_comments_count
  end

  test 'reduce_unhidden_comments_count' do
    post = create_persisted_post

    post.increase_unhidden_comments_count
    post.reduce_unhidden_comments_count

    assert_equal 0, post.unhidden_comments_count
  end
end
