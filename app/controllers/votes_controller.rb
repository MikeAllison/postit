class VotesController < ApplicationController
  before_action :authenticate

  def create

    @post = Post.find(params[:post_id])
    @vote = @post.votes.build(vote_params)
    @vote.creator = current_user

    binding.pry
  end

  private

    def vote_params
      params.permit(:vote)
    end
end
