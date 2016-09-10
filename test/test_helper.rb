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

  # Add more helper methods to be used by all tests here...
  def create_valid_user
    User.create(username: 'auser',
                password: 'password',
                time_zone: 'Eastern Time (US & Canada)')
  end

  def create_valid_post
    p = Post.new(title: 'Valid Title',
                 url: 'http://www.url.com',
                 description: 'A valid description')
    p.categories << Category.create(name: 'News')
    p.save
    return p
  end

  def create_valid_category
    Category.create(name: 'News')
  end

  def create_valid_comment
    Comment.create(body: 'A valid comment')
  end
end
