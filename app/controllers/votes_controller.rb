class VotesController < ApplicationController
  before_action :authenticate
  respond_to :js

  def create
    @post = Post.find(params[:post_id])
    @vote = @post.votes.new
    @vote.vote = params[:vote]
    @vote.creator = current_user

    @vote.save
  end

end
