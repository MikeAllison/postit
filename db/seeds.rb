# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create 75 regular users
75.times do |i|
  User.create(username: "User#{i + 1}", password: "pw", time_zone: Time.zone.name, role: 0)
end

# Create 25 moderators
25.times do |i|
  User.create(username: "User#{i + 76}", password: "pw", time_zone: Time.zone.name, role: 1)
end

# Create an admin and moderator
User.create([
  { username: "AdminUser", password: "pw", time_zone: Time.zone.name, role: 2 },
  { username: "ModerUser", password: "pw", time_zone: Time.zone.name, role: 1 }
])

categories = ["Humor", "Sports", "Technology", "News", "TV & Movies", "Science", "Music", "Education", "Politics"]

9.times do |i|
  Category.create(name: categories[i])
end

descriptions = [
  "lager bitter crystal malt crystal malt cask barley kolsch ester malt. pub copper abv wit? additive, ale chocolate malt mash tun black malt brewing carboy bright beer balthazar. malt, double bock/dopplebock, goblet keg bottom fermenting yeast, heat exchanger bottom fermenting yeast. wort chiller grainy squares. scotch ale cask malt extract, copper hard cider beer bung dextrin squares! krausen pint glass carbonation hydrometer krug. length carboy sour/acidic; dunkle adjunct real ale. heat exchanger. cask conditioned ale dry stout, conditioning, lagering.",
  "cask conditioned ale yeast mead pub wheat beer glass brewhouse. mead pint glass; grainy malt pilsner; anaerobic wort.",
  "attenuation alcohol final gravity biere de garde, brew kettle. pitching beer cask wheat beer glass draft (draught); keg. bung malt extract ester yeast. ibu hand pump malt extract hops anaerobic. mouthfeel aau, chocolate malt kolsch ibu copper, lauter tun bung barrel bock fermentation!"
]

100.times do |i|
  Post.create(url: "http://www.website#{i + 1}.com", title: "Post Title #{i + 1}", description: descriptions.sample, user_id: rand(1..100), category_ids: rand(1..4))
end

300.times do |i|
  Comment.create(body: "This is comment #{i + 1}", user_id: rand(1..100), post_id: rand(1..100))
end

# Calulate unhidden_comments_count column for posts
Post.all.each { |post| post.update(unhidden_comments_count: Comment.where(post_id: post.id, hidden: false).count) }

# Assign a 2nd category to the first 25 posts
25.times do |i|
  c = Category.find(rand(5..7))
  p = Post.find(i + 1)
  p.categories << c
end

# Assign a 3rd category to the first 10 posts
10.times do |i|
  c = Category.find(8)
  p = Post.find(i + 1)
  p.categories << c
end

# Calculate unhidden_posts_count for categories
# No need to include .where(post: { hidden: false }) because Post's default_scope is 'hidden: false'
Category.all.each { |category| category.update(unhidden_posts_count: category.posts.count) }

# Create votes for posts
100.times do |i|
  Vote.create(vote: true, user_id: i + 1, voteable_id: rand(1..100), voteable_type: 'Post')
  Vote.create(vote: false, user_id: i + 1, voteable_id: rand(1..100), voteable_type: 'Post')
end

# Update tallied_votes column for posts
Post.all.each { |post| post.calculate_tallied_votes }

# Create votes for comments
100.times do |i|
  Vote.create(vote: true, user_id: i + 1, voteable_id: rand(1..300), voteable_type: 'Comment')
  Vote.create(vote: false, user_id: i + 1, voteable_id: rand(1..300), voteable_type: 'Comment')
end

# Update tallied_votes column for comments
Comment.all.each { |comment| comment.calculate_tallied_votes }

# Create flags for posts 20-40 (users 76-100 are moderators)
20.times do |i|
  Flag.create(flag: true, user_id: rand(76..100), flagable_id: i + 20, flagable_type: 'Post')
end

# Create flags for comments 20-70 (users 76-100 are moderators)
50.times do |i|
  Flag.create(flag: true, user_id: rand(76..100), flagable_id: i + 20, flagable_type: 'Comment')
end

# Create extra random flags (users 76-100 are moderators)
25.times do |i|
  Flag.create(flag: true, user_id: rand(76..100), flagable_id: rand(20..40), flagable_type: 'Post')
  Flag.create(flag: true, user_id: rand(76..100), flagable_id: rand(20..70), flagable_type: 'Comment')
end

# Update total_flags column for posts
Post.all.each { |post| post.update(total_flags: post.flags.where(flag: true).count) }

# Update total_flags column for comments
Comment.all.each { |comment| comment.update(total_flags: comment.flags.where(flag: true).count) }
