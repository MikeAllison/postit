class CommentsController < ApplicationController
  before_action :authenticate # AppController
  #before_action :require_moderator, only: [:flag]
  before_action :find_comment, only: [:vote, :flag]

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

    @comment.calculate_tallied_votes # Voteable

    respond_to do |format|
      format.html do
        flash[:danger] = @error_msg if @error_msg
        redirect_to :back
      end
      format.js { render 'shared/vote', locals: { obj: @comment } }
    end
  end

  def flag
    @flag = @comment.flags.find_or_initialize_by(flagger: current_user)

    # Convert params[:flag] into boolean for comparison
    submitted_flag = params[:flag] == 'true' ? true : false

    if @flag.new_record?
      @flag.flag = submitted_flag
      @flag.save
    elsif @flag.persisted? && @flag.flag == !submitted_flag
      @flag.update(flag: submitted_flag)
    else
      @error_msg = "Sorry, there was a problem flagging this post."
    end

    respond_to do |format|
      format.html do
        flash[:danger] = @error_msg if @error_msg
        redirect_to :back
      end
      format.js { render 'shared/flag' }
    end
  end

  private

    def find_comment
      @comment = Comment.find(params[:id])
    end

end
