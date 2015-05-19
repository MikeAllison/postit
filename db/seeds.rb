# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

100.times do |i|
  User.create(username: "user#{i + 1}", password: "pw")
end

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
  Post.create(url: "http://www.website#{i + 1}.com", title: "Post Title #{i + 1}", description: descriptions.sample, user_id: rand(1..10), category_ids: rand(1..4))
end

300.times do |i|
  Comment.create(body: "This is comment #{i + 1}", user_id: rand(1..10), post_id: rand(1..100))
end

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

# Create votes for posts
100.times do |i|
  Vote.create(vote: true, user_id: i, voteable_id: rand(1..100), voteable_type: 'Post')
  Vote.create(vote: false, user_id: i, voteable_id: rand(1..100), voteable_type: 'Post')
end

# Create votes for comments
100.times do |i|
  Vote.create(vote: true, user_id: i, voteable_id: rand(1..300), voteable_type: 'Comment')
  Vote.create(vote: false, user_id: i, voteable_id: rand(1..300), voteable_type: 'Comment')
end
