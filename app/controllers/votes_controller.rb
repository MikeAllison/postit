class VotesController < ApplicationController
  before_action :authenticate
  respond_to :js

  def create_post_vote
    @post = Post.find(params[:post_id])
    @vote = @post.votes.new
    @vote.vote = params[:vote]
    @vote.creator = current_user

    if @post.has_same_vote_from?(@vote.creator, @vote.vote)
      render 'post_already_voted_on'
    elsif @post.has_opposite_vote_from?(@vote.creator, @vote.vote)
      @post.votes.find_by("user_id = ?", @vote.creator).update(vote: @vote.vote)
      render 'post_reload_voting'
    else
      @vote.save
      render 'post_reload_voting'
    end
  end

  def create_comment_vote
    @comment = Comment.find(params[:comment_id])
    @vote = @comment.votes.new
    @vote.vote = params[:vote]
    @vote.creator = current_user

    if @comment.has_same_vote_from?(@vote.creator, @vote.vote)
      render 'comment_already_voted_on'
    elsif @comment.has_opposite_vote_from?(@vote.creator, @vote.vote)
      @comment.votes.find_by("user_id = ?", @vote.creator).update(vote: @vote.vote)
      render 'comment_reload_voting'
    else
      @vote.save
      render 'comment_reload_voting'
    end
  end

end
