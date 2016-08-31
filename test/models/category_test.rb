require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'can create a valid category' do
    c = Category.create(name: 'News')
    assert c.persisted?
  end

  test 'cannot save a category without a name' do
    c = Category.create(name: '')
    assert_not c.persisted?
    assert 'Name cannot be blank', c.errors.messages[:name]
  end

  test 'duplicate categories will not be saved' do
    c = Category.create(name: 'News')
    c2 = Category.create(name: 'News')
    assert_not c2.persisted?
    assert 'This category already exists', c2.errors.messages[:name]
  end

  test 'cannot create a category with over 15 characters' do
    c = Category.create(name: 'superlongcategoryname')
    assert_not c.persisted?
    assert 'Category name must be less than 15 characters', c.errors.messages[:name]
  end

  test 'sets unhidden_posts_count to 0 on initialization' do
    c = Category.new
    assert_equal 0, c.unhidden_posts_count
  end

  test 'increase_unhidden_posts_count works' do
    c = Category.create(name: 'News')
    c.increase_unhidden_posts_count
    assert_equal 1, c.unhidden_posts_count
  end

  test 'reduce_unhidden_posts_count works' do
    c = Category.create(name: 'News')
    c.increase_unhidden_posts_count
    c.reduce_unhidden_posts_count
    assert_equal 0, c.unhidden_posts_count
  end
end
