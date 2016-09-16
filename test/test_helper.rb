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
  def create_standard_user(id = 1)
    User.create(username: "user#{id}",
                password: 'password',
                time_zone: 'Eastern Time (US & Canada)',
                role: 0)
  end

  def create_moderator_user(id = 1)
    User.create(username: "moderator#{id}",
                password: 'password',
                time_zone: 'Eastern Time (US & Canada)',
                role: 1)
  end

  def create_admin_user(id = 1)
    User.create(username: "admin#{id}",
                password: 'password',
                time_zone: 'Eastern Time (US & Canada)',
                role: 2)
  end

  # Session
  def login(user)
    post login_path, { username: user.username, password: 'password' }

    return User.find_by(id: session[:current_user_id])
  end

  def logout!
    get logout_path
  end

  # Category
  def create_persisted_category(cat_id = 1)
    Category.create(name: "Category #{cat_id}")
  end

  # Post
  def create_persisted_post(post_id = 1, cat_id = 1)
    post = Post.new(title: "Valid Title #{post_id}",
                    url: "http://www.url#{post_id}.com",
                    description: "Description #{post_id}")

    if cat_id != 1
      post.categories << create_persisted_category(cat_id)
    else
      post.categories << create_persisted_category
    end

    post.creator = create_standard_user
    post.save

    return post
  end

  def create_post_by_user(user, post_id = 1, cat_id = 1)
    post = create_persisted_post(post_id, cat_id)
    post.creator = user
    post.save

    return post
  end

  # Comment
  def create_persisted_comment(id = 1)
    Comment.create(body: "Comment #{id}")
  end
end
