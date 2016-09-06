75.times do |i|
  User.create(username: "User#{i + 1}", password: 'pw', time_zone: Time.zone.name, role: 0)
end

# Create 25 moderators
25.times do |i|
  User.create(username: "User#{i + 76}", password: 'pw', time_zone: Time.zone.name, role: 1)
end

categories = ['Humor', 'Sports', 'Technology', 'News', 'TV & Movies', 'Science', 'Music', 'Education', 'Politics']

9.times do |i|
  Category.create(name: categories[i])
end

# Descriptions
humor = [
  'LOL.  Funny Jokes!  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
  'Can you believe this?!?!?! Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
  'I can look at memes all day!!!  Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum voluptate velit ess sed do eiusmod tempor incididunt.'
]
sports = [
  'Reactions to the big game...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
  'Trades that will have a major impact on the upcomping season.  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
  'Last night\'s scores.  Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum voluptate velit ess sed do eiusmod tempor incididunt.'
]
technology = [
  'From CNET:  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
  'The latest gadget news from Engadget.  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
  'Look at this story on Wired!  Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum voluptate velit ess sed do eiusmod tempor incididunt.'
]
news = [
  'Check out this story on Google News!  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
  'News from around the world.  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
  'This local story is crazy!  Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum voluptate velit ess sed do eiusmod tempor incididunt.'
]

# Create humor posts
25.times do |i|
  Post.create(url: "http://www.humor-website#{i + 1}.com",
              title: "Post #{i + 1}",
              description: humor.sample,
              user_id: rand(1..100),
              category_ids: 1)
end

# Create sports posts
25.times do |i|
  Post.create(url: "http://www.sports-website#{i + 1}.com",
              title: "Post #{i + 26}",
              description: sports.sample,
              user_id: rand(1..100),
              category_ids: 2)
end

# Create technology posts
25.times do |i|
  Post.create(url: "http://www.tech-website#{i + 1}.com",
              title: "Post #{i + 51}",
              description: technology.sample,
              user_id: rand(1..100),
              category_ids: 3)
end

# Create news posts
25.times do |i|
  Post.create(url: "http://www.news-website#{i + 1}.com",
              title: "Post #{i + 76}",
              description: news.sample,
              user_id: rand(1..100),
              category_ids: 4)
end

300.times do |i|
  Comment.create(body: "This is comment #{i + 1}",
                 user_id: rand(1..100),
                 post_id: rand(1..100))
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
Post.all.each(&:calculate_tallied_votes)

# Create votes for comments
100.times do |i|
  Vote.create(vote: true, user_id: i + 1, voteable_id: rand(1..300), voteable_type: 'Comment')
  Vote.create(vote: false, user_id: i + 1, voteable_id: rand(1..300), voteable_type: 'Comment')
end

# Update tallied_votes column for comments
Comment.all.each(&:calculate_tallied_votes)

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
