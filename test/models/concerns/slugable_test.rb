require 'test_helper'

class SlugableTest < ActiveSupport::TestCase
  test 'set_slugable_attribute' do
    Post.set_slugable_attribute(:title)

    assert_equal :title, Post.slugged_attribute
  end

  test 'to_slug/create_slug' do
    post = create_persisted_post(1)
    post2 = create_persisted_post(2)
    post3 = create_persisted_post(3)
    post4 = create_persisted_post(4)

    post.title = 'Title 1'
    post.save
    assert_equal 'title-1', post.slug

    # Test that resaving the same title doesn't change it
    post.title = 'Title 1'
    post.save
    assert_equal 'title-1', post.slug

    # Test that creating a post with an existing slug increments it
    post2.title = 'Title 1'
    post2.save
    assert_equal 'title-1-2', post2.slug

    post3.title = 'Title 1'
    post3.save
    assert_equal 'title-1-3', post3.slug

    # Test for duplicate slug
    post4.title = 'Title 1 3'
    post4.save
    assert_equal 'title-1-3-2', post4.slug

    # Test substitutions
    post.title = "    Title     2     "
    post.save
    assert_equal 'title-2', post.slug

    post.title = '   ----  Ti#$tle-- -  --3--   --   '
    post.save
    assert_equal 'ti-tle-3', post.slug
  end

   test 'slug_unchanged' do
     post = create_persisted_post

     assert post.send(:slug_unchanged?, 'title-1')
     assert_not post.send(:slug_unchanged?, 'title-2')
   end

   test 'slug_unique?' do
     post = create_persisted_post

     assert post.send(:slug_unique?, 'title-2')
     assert_not post.send(:slug_unique?, 'title-1')
   end
end
