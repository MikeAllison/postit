class Comment < ActiveRecord::Base

  include Voteable # In 'models/concerns'

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post, counter_cache: :comments_count

  validates_presence_of :body, message: "Comment cannot be blank"

  after_initialize :set_default_votes, if: :new_record? # Voteable

end
