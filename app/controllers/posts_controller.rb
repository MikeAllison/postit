class PostsController < ApplicationController
  before_action :authenticate, except: [:index, :show]
  before_action :find_post, only: [:show, :edit, :update, :vote]
  before_action :restrict_post_editing, only: [:edit, :update, :destroy]
  respond_to :html, :js

  def index
    @posts = Post.includes(:creator, :categories, :comments).sort_by { |post| post.tally_votes }.reverse
  end

  def new
    @post = Post.new

    if Category.count.eql?(0)
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
    @vote = @post.votes.find_or_initialize_by(creator: current_user)

    # Convert params[:vote] into boolean for comparison
    vote = params[:vote] == 'true' ? true : false

    if @vote.new_record?
      @vote.vote = vote
      @vote.save
      render 'votes/post_reload_voting'
    elsif @vote.persisted? && @vote.vote == vote
      render 'votes/post_already_voted'
    else
      @vote.update(vote: params[:vote])
      render 'votes/post_reload_voting'
    end
  end

  private

    def find_post
      @post = Post.find(params[:id])
    end

    def restrict_post_editing
      if @post.creator != current_user
        flash[:danger] = "Access Denied - You may only edit posts that you've created."
        redirect_to @post
      end
    end

    def post_params
      params.require(:post).permit(:title, :url, :description, :category_ids => [])
    end
end
