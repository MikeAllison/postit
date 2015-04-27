class CommentsController < ApplicationController
  before_action :authenticate

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = current_user

    if @comment.save
      flash[:success] = 'Your comment was added.'
      redirect_to @post
    else
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = @comment.votes.find_or_initialize_by(creator: current_user)

    # Convert params[:vote] into boolean for comparison
    vote = params[:vote] == 'true' ? true : false

    if @vote.new_record?
      @vote.vote = vote
      @vote.save
      render 'votes/comment_reload_voting'
    elsif @vote.persisted? && @vote.vote == vote
      render 'votes/comment_already_voted'
    else
      @vote.update(vote: params[:vote])
      render 'votes/comment_reload_voting'
    end
  end

end
