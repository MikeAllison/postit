class Comment < ActiveRecord::Base
  include Flagable # In 'models/concerns'
  include Voteable # In 'models/concerns'

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post
  
  default_scope { where(hidden: false) }

  validates_presence_of :body, message: 'Comment cannot be blank'

  after_initialize :initialize_tallied_votes, if: :new_record? # Voteable

  def clear_flags
    Comment.transaction do
      self.flags.each(&:destroy)
      self.reset_total_flags
    end
  end

  def hide
    Comment.transaction do
      self.update(hidden: true)
      self.votes.each(&:destroy)
      self.flags.each(&:destroy)
      self.post.reduce_unhidden_comments_count
    end
  end
end
