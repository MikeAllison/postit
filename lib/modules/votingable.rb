module Votingable
  def tallied_votes
    total_votes = 0
    upvotes = self.votes.where("vote = ?", true).count
    downvotes = self.votes.where("vote = ?", false).count

    total_votes = upvotes - downvotes
  end

  def has_same_vote_from?(user, vote)
    return true if self.votes.where("user_id = ? and vote = ?", user, vote).exists?
  end

  def has_opposite_vote_from?(user, vote)
    return true if self.votes.where("user_id = ? and vote != ?", user, vote).exists?
  end
end
