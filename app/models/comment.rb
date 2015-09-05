class Comment < ActiveRecord::Base

  include Flagable # In 'models/concerns'
  include Voteable # In 'models/concerns'

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post

  validates_presence_of :body, message: "Comment cannot be blank"

  after_initialize :initialize_tallied_votes, if: :new_record? # Voteable

  def clear_flags
    Comment.transaction do
      self.flags.each { |flag| flag.destroy }
      self.reset_total_flags
    end
  end

  def hide
    Comment.transaction do
      self.update(hidden: true)
      self.votes.each { |vote| vote.destroy }
      self.flags.each { |flag| flag.destroy }
      self.post.reduce_unhidden_comments_count
    end
  end

end
