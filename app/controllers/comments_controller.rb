class CommentsController < ApplicationController
  before_action :authenticate

  def create
    @post = Post.find_by(slug: params[:post_id])
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
    submitted_vote = params[:vote] == 'true' ? true : false

    if @vote.new_record?
      @vote.vote = submitted_vote
      @vote.save
    elsif @vote.persisted? && @vote.vote == !submitted_vote
      @vote.update(vote: submitted_vote)
    elsif @vote.persisted? && @vote.vote == submitted_vote
      @error_msg = "You've already voted on this comment."
    else
      @error_msg = "Sorry, your vote couldn't be counted."
    end

    respond_to do |format|
      format.html do
        redirect_to :back
        flash[:danger] = @error_msg if @error_msg
      end
      format.js { render 'shared/vote', locals: { obj: @comment } }
    end
  end

end
