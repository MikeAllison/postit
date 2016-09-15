ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'pry'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # User
  def create_standard_user
    User.create(username: 'user',
                password: 'password',
                time_zone: 'Eastern Time (US & Canada)')
  end

  def create_standard_user2
    User.create(username: 'user2',
                password: 'password',
                time_zone: 'Eastern Time (US & Canada)')
  end

  def create_moderator_user
    User.create(username: 'moderator',
                password: 'password',
                time_zone: 'Eastern Time (US & Canada)',
                role: 1)
  end

  def create_admin_user
    User.create(username: 'admin',
                password: 'password',
                time_zone: 'Eastern Time (US & Canada)',
                role: 2)
  end

  # Session
  def login(user)
    post login_path, { username: user.username, password: 'password' }

    return User.find_by(id: session[:current_user_id])
  end

  # Category
  def create_persisted_category
    Category.create(name: 'News')
  end

  # Post
  def create_post(user)
    post = user.posts.create(title: 'New Post',
                      url: 'http://www.example.com',
                      description: 'A cool site.')
    post.categories << create_persisted_category
    post.creator = user
    post.save

    return post
  end

  def create_persisted_post
    post = Post.new(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    post.categories << create_persisted_category
    post.creator = create_standard_user
    post.save

    return post
  end

  # Comment
  def create_persisted_comment
    Comment.create(body: 'A valid comment')
  end
end
