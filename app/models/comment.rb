class Comment < ActiveRecord::Base

  include Flagable # In 'models/concerns'
  include Voteable # In 'models/concerns'

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post, counter_cache: :comments_count

  validates_presence_of :body, message: "Comment cannot be blank"

  after_initialize :initialize_hidden_attr, if: :new_record? # Flagable
  after_initialize :initialize_flags_count, if: :new_record? # Flagable
  after_initialize :initialize_tallied_votes, if: :new_record? # Voteable

end
