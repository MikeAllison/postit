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
      self.update(total_flags: 0)
    end
  end

  def hide
    Comment.transaction do
      self.update(hidden: true)
      self.votes.each { |vote| vote.destroy }
      self.flags.each { |flag| flag.destroy }
      self.post.update(unhidden_comments_count: self.post.unhidden_comments_count -= 1)
    end
  end

end
