class PostCategory < ActiveRecord::Base
  belongs_to :post
  belongs_to :category, counter_cache: :posts_count
end
