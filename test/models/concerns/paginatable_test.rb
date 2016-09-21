require 'test_helper'

class PaginatableTest < ActiveSupport::TestCase
  test 'set_items_per_page' do
    Post.set_items_per_page(3)

    assert_equal 3, Post.items_per_page
  end

  test 'set_links_per_page' do
    Post.set_links_per_page(5)

    assert_equal 5, Post.links_per_page
  end

  test 'total_pages' do
    # 10 posts
    Post.set_items_per_page(3)

    10.times do |i|
      create_persisted_post(i + 1)
    end

    assert_equal 4, Post.total_pages

    # 9 posts
    Post.last.destroy!

    assert_equal 3, Post.total_pages
  end

  test 'paginate' do
    # 10 posts
    Post.set_items_per_page(4)

    posts = []

    10.times do |i|
       posts << create_persisted_post(i + 1)
    end

    page1 = Post.paginate(1)
    assert_equal 4, page1.count
    assert_equal page1, posts[0..3]

    page2 = Post.paginate(2)
    assert_equal 4, page2.count
    assert_equal page2, posts[4..7]

    page3 = Post.paginate(3)
    assert_equal 2, page3.count
    assert_equal page3, posts[8..9]
  end
end
