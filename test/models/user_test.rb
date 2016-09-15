require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'can create a valid user' do
    user = create_standard_user

    assert user.persisted?
  end

  test 'cannot save a user without a username' do
    user = create_standard_user
    user.username = ''

    assert_not user.save
    assert_equal 'Please enter a username', user.errors.messages[:username].first
  end

  test 'username cannot contain spaces' do
    user = create_standard_user
    user.username = 'a user'

    assert_not user.save
    assert_equal 'Username cannot contain spaces', user.errors.messages[:username].first
  end

  test 'username must start with a letter or number' do
    user = create_standard_user
    user.username = '-auser'

    assert_not user.save
    assert_equal 'Username must start with a letter or number', user.errors.messages[:username].first
  end

  test 'username must only contain letters, numbers, or dashes' do
    user = create_standard_user
    user.username = 'au@ser'

    assert_not user.save
    assert_equal 'Username may only contain: letters, numbers, and dashes', user.errors.messages[:username].first
  end

  test 'username must end with a letter or number' do
    user = create_standard_user
    user.username = 'auser-'

    assert_not user.save
    assert_equal 'Username must end with a letter or number', user.errors.messages[:username].first
  end

  test 'username must be < 20 characters' do
    user = create_standard_user
    user.username = 'areallyreallyreallylongusername'

    assert_not user.save
    assert_equal 'Username must be less than 20 characters', user.errors.messages[:username].first
  end

  test 'username must be unique' do
    create_standard_user
    user2 = create_standard_user

    assert_not user2.save
    assert_equal 'This username is not available', user2.errors.messages[:username].first
  end

  test 'password cannot be blank' do
    user =User.create(username: 'auser', password: '', time_zone: 'Eastern Time (US & Canada)')

    assert_not user.save
    assert_equal "Password can't be blank", user.errors.messages[:password].first
  end

  test 'passwords must match' do
    user =User.create(username: 'auser', password: 'password', password_confirmation: 'notpassword', time_zone: 'Eastern Time (US & Canada)')

    assert_not user.save
    assert_equal "The passwords don't match", user.errors.messages[:password_confirmation].first
  end

  test 'timezome must be valid' do
    user = create_standard_user
    user.time_zone = 'Not valid'

    assert_not user.save
    assert_equal 'The time zone is not valid', user.errors.messages[:time_zone].first
  end

  test 'User.search returns all values when a search term is not specified' do
    all_users = []
    [create_standard_user, create_moderator_user, create_admin_user].each do |user|
      all_users << user
    end

    search_results = User.search(nil)

    assert_equal all_users, search_results
  end

  test 'User.search can find a user by username' do
    user = create_standard_user

    search_results = User.search(user.username)

    assert_equal [user], search_results
  end

  test 'set_default_status' do
    user =User.new

    assert_equal false, user.disabled
  end

  test 'set_default_role' do
    user =User.new

    assert user.user?
  end

  test 'disable!' do
    user = create_standard_user
    user.disable!
    user.reload

    assert user.disabled?
  end

  test 'enable!' do
    user = create_standard_user
    user.disabled = true
    user.save
    user.enable!
    user.reload

    assert_not user.disabled?
  end

  test 'strip_username_whitespace' do
    user = create_standard_user
    user.username = '     auser   '
    user.save

    assert_equal 'auser', user.username
  end

  test 'username_role' do
    user = create_standard_user
    user.moderator!

    assert_equal 'user [moderator]', user.username_role
  end
end
