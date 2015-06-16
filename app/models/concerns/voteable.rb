module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable

    scope :votes_created_desc, -> { order(tallied_votes: :desc, created_at: :desc) }
  end

  def initialize_tallied_votes
    self.tallied_votes = 0
  end

  def upvotes
    self.votes.where("vote = ?", true).count
  end

  def downvotes
    self.votes.where("vote = ?", false).count
  end

  # Requires a tallied_votes column in the model's table
  def calculate_tallied_votes
    self.tallied_votes = upvotes - downvotes
    self.save
  end

  def vote_exists?(user, vote)
    self.votes.where("user_id = ? and vote = ?", user, vote).exists?
  end

end
