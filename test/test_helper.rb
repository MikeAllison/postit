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

  # Session
  def log_in_standard_user
    post login_path, { username: 'user', password: 'password' }
  end

  def log_in_moderator_user
    post login_path, { username: 'moderator', password: 'password' }
  end

  def log_in_admin_user
    post login_path, { username: 'admin', password: 'password' }
  end

  # User
  def create_standard_user
    User.create(username: 'user',
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

  # Post
  def create_valid_post
    p = Post.new(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    return p
  end

  # Category
  def create_valid_category
    Category.create(name: 'News')
  end

  # Comment
  def create_valid_comment
    Comment.create(body: 'A valid comment')
  end
end
