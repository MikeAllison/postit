class PostsController < ApplicationController
  before_action :authenticate, except: [:index, :show]
  before_action :find_post, only: [:show, :edit, :update, :vote]
  before_action :restrict_post_editing, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:creator, :categories, :comments).sort_by { |post| post.tallied_votes }.reverse
  end

  def new
    @post = Post.new

    if !Category.any?
      flash[:danger] = "Please add a category before creating a post."
      redirect_to new_category_path
    end
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:success] = "Your post was created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:success] = "Your post was updated."
      redirect_to posts_path
    else
      render :edit
    end
  end

  def vote
    @already_voted = @misc_error = false

    @vote = @post.votes.find_or_initialize_by(creator: current_user)

    # Convert params[:vote] into boolean for comparison
    submitted_vote = params[:vote] == 'true' ? true : false

    if @vote.new_record?
      @vote.vote = submitted_vote
      @vote.save
    elsif @vote.persisted? && @vote.vote == !submitted_vote
      @vote.update(vote: submitted_vote)
    elsif @vote.persisted? && @vote.vote == submitted_vote
      @already_voted = true
      message = "You've already voted on this post."
    else
      @misc_error = true
      message = "Sorry, your vote couldn't be counted."
    end

    respond_to do |format|
      format.html do
        flash[:danger] = message if message
        redirect_to :back
      end
      format.js { render 'shared/vote', locals: { obj: @post } }
    end
  end

  private

    def find_post
      @post = Post.find_by_slug(params[:id])
    end

    def restrict_post_editing
      if @post.creator != current_user
        flash[:danger] = "Access Denied! - You may only edit posts that you've created."
        redirect_to @post
      end
    end

    def post_params
      params.require(:post).permit(:title, :url, :description, :category_ids => [])
    end

end
