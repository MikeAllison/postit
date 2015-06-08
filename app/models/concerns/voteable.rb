module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable    
  end

  def tallied_votes
    upvotes = self.votes.where("vote = ?", true).count
    downvotes = self.votes.where("vote = ?", false).count

    upvotes - downvotes
  end

  def has_same_vote_from?(user, vote)
    self.votes.where("user_id = ? and vote = ?", user, vote).exists?
  end

end
