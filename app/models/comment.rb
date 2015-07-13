class Comment < ActiveRecord::Base

  include Flagable # In 'models/concerns'
  include Voteable # In 'models/concerns'

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post

  validates_presence_of :body, message: "Comment cannot be blank"

  after_initialize :initialize_tallied_votes, if: :new_record? # Voteable

end
