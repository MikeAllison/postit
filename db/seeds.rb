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

categories = ["Humor", "Sports", "Technology", "News", "TV & Movies", "Science", "Music", "Education"]

8.times do |i|
  Category.create(name: categories[i])
end

descriptions = [
  "lager bitter crystal malt crystal malt cask barley kolsch ester malt. pub copper abv wit? additive, ale chocolate malt mash tun black malt brewing carboy bright beer balthazar. malt, double bock/dopplebock, goblet keg bottom fermenting yeast, heat exchanger bottom fermenting yeast. wort chiller grainy squares. scotch ale cask malt extract, copper hard cider beer bung dextrin squares! krausen pint glass carbonation hydrometer krug. length carboy sour/acidic; dunkle adjunct real ale. heat exchanger. cask conditioned ale dry stout, conditioning, lagering.",
  "cask conditioned ale yeast mead pub wheat beer glass brewhouse. mead pint glass; grainy malt pilsner; anaerobic wort.",
  "attenuation alcohol final gravity biere de garde, brew kettle. pitching beer cask wheat beer glass draft (draught); keg. bung malt extract ester yeast. ibu hand pump malt extract hops anaerobic. mouthfeel aau, chocolate malt kolsch ibu copper, lauter tun bung barrel bock fermentation!"
]

50.times do |i|
  Post.create(url: "www.website#{i + 1}.com", title: "Title #{i + 1}", description: descriptions.sample, user_id: rand(1..10))
end

30.times do |i|
  Comment.create(body: "This is comment #{i + 1}", user_id: rand(1..10), post_id: rand(1..50))
end

# Assign a category to every post
50.times do |i|
  PostCategory.create(post_id: i + 1, category_id: rand(1..5))
end

# Assign extra categories to a random posts
40.times do |i|
  PostCategory.create(post_id: rand(1..50), category_id: rand(6..8))
end
