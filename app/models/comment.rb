class Comment < ActiveRecord::Base
  include Votingable

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post, counter_cache: :comments_count
  has_many :votes, as: :voteable

  validates_presence_of :body, message: "Comment cannot be blank"

end
