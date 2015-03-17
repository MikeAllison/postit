# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do |i|
  User.create(username: "User #{i + 1}")
end

10.times do |i|
  Category.create(name: "Category #{i + 1}")
end

50.times do |i|
  description = "This is description #{i + 1}."
  Post.create(url: "www.site#{i + 1}.com", title: "Title #{i + 1}", description: description, user_id: rand(1..10))
end

30.times do |i|
  Comment.create(body: "This is comment #{i + 1}", user_id: rand(1..10), post_id: rand(1..50))
end

# Assign a category to every post
50.times do |i|
  PostCategory.create(post_id: i + 1, category_id: rand(1..5))
end

# Assign extra categories to a random posts
25.times do |i|
  PostCategory.create(post_id: rand(1..50), category_id: rand(6..10))
end
