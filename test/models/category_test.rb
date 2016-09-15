require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'can create a valid category' do
    cat = create_persisted_category


    assert cat.persisted?
  end

  test 'cannot save a category without a name' do
    cat = Category.create(name: '')

    assert_not cat.persisted?
    assert_equal 'Name cannot be blank', cat.errors.messages[:name].first
  end

  test 'duplicate categories will not be saved' do
    create_persisted_category
    cat2 = create_persisted_category

    assert_not cat2.persisted?
    assert_equal 'This category already exists', cat2.errors.messages[:name].first
  end

  test 'cannot create a category with over 15 characters' do
    cat = Category.create(name: 'superlongcategoryname')

    assert_not cat.persisted?
    assert_equal 'Category name must be less than 15 characters', cat.errors.messages[:name].first
  end

  test 'initialize_hidden' do
    cat = Category.new

    assert_equal false, cat.hidden
  end

  test 'initialize_posts_count' do
    cat = Category.new

    assert_equal 0, cat.unhidden_posts_count
  end

  test 'hide!' do
    cat = create_persisted_category

    cat.hide!
    cat.reload

    assert cat.hidden?
  end

  test 'unhide!' do
    cat = create_persisted_category

    cat.hide!
    cat.unhide!
    cat.reload

    assert_equal false, cat.hidden?
  end

  test 'increase_unhidden_posts_count' do
    cat = create_persisted_category

    cat.increase_unhidden_posts_count

    assert_equal 1, cat.unhidden_posts_count
  end

  test 'reduce_unhidden_posts_count' do
    cat = create_persisted_category

    cat.increase_unhidden_posts_count
    cat.reduce_unhidden_posts_count

    assert_equal 0, cat.unhidden_posts_count
  end
end
