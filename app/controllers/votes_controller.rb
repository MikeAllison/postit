class VotesController < ApplicationController
  before_action :authenticate
  respond_to :js

  def create
    @post = Post.find(params[:post_id])
    @vote = @post.votes.new
    @vote.vote = params[:vote]
    @vote.creator = current_user

    if @post.has_vote_from?(@vote.creator, @vote.vote)
      render js: 'bootbox.alert("You\'ve already voted on this post.");'
    elsif @post.can_update_vote?(@vote.creator, @vote.vote)
      @post.votes.find_by("user_id = ?", @vote.creator).update(vote: @vote.vote)
    else
      @vote.save
    end
  end

end
