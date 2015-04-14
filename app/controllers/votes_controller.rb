class VotesController < ApplicationController
  before_action :authenticate

  def create

    @post = Post.find(params[:post_id])
    @vote = @post.votes.build(vote: params[:vote], creator: current_user)
    #@vote.vote = params[:vote]
    #@vote.creator = current_user

    binding.pry
  end
end
