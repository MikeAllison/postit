class Comment < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post
  has_many :votes, as: :voteable

  validates_presence_of :body, message: "Comment cannot be blank"

  def has_same_vote_from?(user, vote)
    return true if self.votes.where("user_id = ? and vote = ?", user, vote).exists?
  end

  def has_opposite_vote_from?(user, vote)
    return true if self.votes.where("user_id = ? and vote != ?", user, vote).exists?
  end
end
