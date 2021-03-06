class PostsController < ApplicationController
  helper PaginationHelper

  before_action :authenticate, except: [:index, :show] # AppController
  before_action :require_admin, only: [:clear_flags, :hide]
  before_action :require_moderator_or_admin, only: [:flag]
  before_action :find_post, only: [:show, :edit, :update, :vote, :flag,
                                   :clear_flags, :hide]
  before_action :require_current_user_or_admin, only: [:edit, :update]
  before_action :catch_invalid_params, only: [:vote, :flag] # AppController

  def index
    @posts = Post.includes(:categories, :creator).votes_created_desc

    respond_to do |format|
      format.html
      format.js { render 'shared/reload_posts' }
    end
  end

  def new
    @post = Post.new

    return if Category.any?
    flash[:danger] = 'Please add a category before creating a post.'
    redirect_to new_admin_category_path
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      @post.categories.each(&:increase_unhidden_posts_count)
      flash[:success] = 'Your post was created.'
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
      flash[:success] = 'Your post was updated.'
      redirect_to @post
    else
      render :edit
    end
  end

  def vote
    @vote = @post.votes.find_or_initialize_by(creator: current_user)

    # Convert params[:vote] into boolean for comparison
    submitted_vote = params[:vote] == 'true' ? true : false

    Post.transaction do
      if @post.flagged? # In Flagable
        @error_msg = 'You may not vote on a post that has been flagged for review.'
      elsif @vote.new_record?
        @vote.vote = submitted_vote
        @vote.save
      elsif @vote.opposite_exists?(submitted_vote)
        @vote.destroy!
      elsif @vote.already_exists?(submitted_vote)
        @error_msg = "You've already voted on this post."
      end

      # Only caluluate votes if there's no error message
      @post.calculate_tallied_votes unless @error_msg # Voteable
    end

    respond_to do |format|
      format.html do
        flash[:danger] = @error_msg if @error_msg
        redirect_to :back
      end
      format.js { render 'shared/vote', locals: { obj: @post } }
    end
  end

  def flag
    @flag = @post.flags.find_or_initialize_by(flagger: current_user)

    # Convert params[:flag] into boolean for comparison
    submitted_flag = params[:flag] == 'true' ? true : false

    if @flag.new_record?
      @flag.flag = submitted_flag
      @flag.save
    elsif @flag.opposite_exists?(submitted_flag)
      @flag.update(flag: submitted_flag)
    else
      @error_msg = 'Sorry, there was a problem flagging this post.'
    end

    respond_to do |format|
      format.html do
        flash[:danger] = @error_msg if @error_msg
        redirect_to :back
      end
      format.js { render 'shared/flag', locals: { obj: @post.reload } }
    end
  end

  def clear_flags
    @post.clear_flags

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'shared/update_admin_flagged', locals: { obj: @post } }
    end
  end

  def hide
    @post.hide

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'shared/update_admin_flagged', locals: { obj: @post } }
    end
  end

  private

  def find_post
    @post = Post.find_by!(slug: params[:id])
  end

  def require_current_user_or_admin
    return unless @post.creator != current_user && !current_user.admin?
    flash[:danger] = "Access Denied! - You may only edit posts that you've created."
    redirect_to @post
  end

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end
end
