require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'can create a valid user' do
    u = User.create(username: 'auser', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    assert u.persisted?
  end

  test 'cannot create a user without a username' do
    u = User.create(username: '', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    assert_not u.persisted?
    assert_equal 'Please enter a username', u.errors.messages[:username].first
  end

  test 'username cannot contain spaces' do
    u = User.create(username: 'a user', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    assert_not u.persisted?
    assert_equal 'Username cannot contain spaces', u.errors.messages[:username].first
  end

  test 'username must start with a letter or number' do
    u = User.create(username: '-auser', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    assert_not u.persisted?
    assert_equal 'Username must start with a letter or number', u.errors.messages[:username].first
  end

  test 'username must only contain letters, numbers, or dashes' do
    u = User.create(username: 'au@ser', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    assert_not u.persisted?
    assert_equal 'Username may only contain: letters, numbers, and dashes', u.errors.messages[:username].first
  end

  test 'username must end with a letter or number' do
    u = User.create(username: 'auser-', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    assert_not u.persisted?
    assert_equal 'Username must end with a letter or number', u.errors.messages[:username].first
  end

  test 'username must be < 20 characters' do
    u = User.create(username: 'areallyreallyreallylongusername', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    assert_not u.persisted?
    assert_equal 'Username must be less than 20 characters', u.errors.messages[:username].first
  end

  test 'username must be unique' do
    u = User.create(username: 'auser', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    u2 = User.create(username: 'auser', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    assert_not u2.persisted?
    assert_equal 'This username is not available', u2.errors.messages[:username].first
  end

  test 'password cannot be blank' do
    u = User.create(username: 'auser', password: '', time_zone: 'Eastern Time (US & Canada)')
    assert_not u.persisted?
    assert_equal "Password can't be blank", u.errors.messages[:password].first
  end

  test 'passwords must match' do
    u = User.create(username: 'auser', password: 'password', password_confirmation: 'notpassword', time_zone: 'Eastern Time (US & Canada)')
    assert_not u.persisted?
    assert_equal "The passwords don't match", u.errors.messages[:password_confirmation].first
  end

  test 'timezome must be valid' do
    u = User.create(username: 'auser', password: 'password', time_zone: 'Eastern (US & Canada)')
    assert_not u.persisted?
    assert_equal 'The time zone is not valid', u.errors.messages[:time_zone].first
  end

  test 'set_default_status' do
    u = User.new
    assert_equal false, u.disabled
  end

  test 'set_default_role' do
    u = User.new
    assert u.user?
  end

  test 'disable!' do
    u = User.create(username: 'auser', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    u.disable!
    u.reload
    assert u.disabled?
  end

  test 'enable!' do
    u = User.create(username: 'auser', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    u.disabled = true
    u.save
    u.enable!
    u.reload
    assert_not u.disabled?
  end

  test 'strip_username_whitespace' do
    u = User.create(username: '   auser    ', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    assert_equal 'auser', u.username
  end

  test 'username_role' do
    u = User.create(username: 'auser', password: 'password', time_zone: 'Eastern Time (US & Canada)')
    u.moderator!
    assert_equal 'auser [moderator]', u.username_role
  end
end
