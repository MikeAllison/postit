class CommentsController < ApplicationController
  before_action :authenticate

  def create
    @post = Post.find_by_slug(params[:post_id])
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
    @already_voted = @misc_error = false

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
      @already_voted = true
      message = "You've already voted on this comment."
    else
      @misc_error = true
      message = "Sorry, your vote couldn't be counted."
    end

    respond_to do |format|
      format.html do
        redirect_to :back
        flash[:danger] = message if message
      end
      format.js { render 'shared/vote', locals: { obj: @comment } }
    end
  end

end
