require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'can create a valid post' do
    p = Post.new(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    assert p.persisted?
  end

  test 'cannot save without a title' do
    p = Post.new(title: '',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    assert_not p.persisted?
    assert_equal "Title field can't be blank", p.errors.messages[:title].first
  end

  test 'cannot save with a title < 2 characters' do
    p = Post.new(title: 'A',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    assert_not p.persisted?
    assert_equal 'Title is too short (minimum is 2 characters)', p.errors.messages[:title].first
  end

  test 'cannot save without a url' do
    p = Post.new(title: 'Valid Title',
                 url: '',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    assert_not p.persisted?
    assert_equal "URL field can't be blank", p.errors.messages[:url].first
  end

  test 'cannot save a duplicate URL' do
    p = Post.new(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save

    p2 = Post.new(title: 'Valid Title 2',
                 url: 'http://www.url.com',
                 description: 'A valid description 2')
    p2.categories << Category.create(name: 'News')
    p2.save
    assert_not p2.persisted?
    assert_equal 'This URL has already been posted', p2.errors.messages[:url].first
  end

  test 'cannot save an invalid url' do
    p = Post.new(title: 'Valid Title',
                 url: 'www.abc.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    assert_not p.persisted?
    assert_equal 'URL field must be a valid URL (ex. http://www.example.com)', p.errors.messages[:url].first
  end

  test 'cannot save without a description' do
    p = Post.new(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: '')
    p.categories << Category.create(name: 'News')
    p.save
    assert_not p.persisted?
    assert_equal "Description field can't be blank", p.errors.messages[:description].first
  end

  test 'cannot save a post without a category' do
    p = Post.create(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    assert_not p.persisted?
    assert_equal 'Please select at least one category', p.errors.messages[:categories].first
  end

  test 'initialize_unhidden_comments_count' do
    p = Post.new
    assert_equal 0, p.unhidden_comments_count
  end

  test 'initialize_tallied_votes' do
    p = Post.new
    assert_equal 0, p.tallied_votes
  end

  test 'strip_url_whitespace' do
    p = Post.new(title: 'Valid Title',
                 url: ' http://www.a  bc.com  ',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    assert p.persisted?
    assert_equal 'http://www.abc.com', p.url
  end

  test 'downcase_url' do
    p = Post.new(title: 'Valid Title',
                 url: 'hTTP://wWw.ABc.cOM',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    assert p.persisted?
    assert_equal 'http://www.abc.com', p.url
  end

  test 'clear_flags' do
    p = Post.new(title: 'Valid Title',
                 url: 'http://www.abc.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    2.times do
      p.flags.create
    end
    p.clear_flags
    assert_equal 0, p.flags.count
    assert_equal 0, p.total_flags
  end

  test 'hide' do
    p = Post.new(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    2.times do
      p.votes.create
      p.flags.create
      p.comments.create(body: 'A valid comment')
      2.times do
        p.comments.each do |comment|
          comment.votes.create
          comment.flags.create
        end
      end
    end

    p.hide
    assert p.hidden
    assert_equal 0, p.votes.count
    assert_equal 0, p.flags.count
    p.comments.each do |comment|
      assert_equal 0, comment.votes.count
      assert_equal 0, comment.flags.count
      assert comment.hidden
    end
    assert_equal -1, p.categories.where(name: 'News').first.unhidden_posts_count
  end

  test 'increase_unhidden_comments_count' do
    p = Post.new(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    p.increase_unhidden_comments_count
    assert_equal 1, p.unhidden_comments_count
  end

  test 'reduce_unhidden_comments_count' do
    p = Post.new(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    p.increase_unhidden_comments_count
    p.reduce_unhidden_comments_count
    assert_equal 0, p.unhidden_comments_count
  end
end
