class PostsController < ApplicationController
  helper PaginationHelper

  before_action :authenticate, except: [:index, :show] # AppController
  before_action :require_admin, only: [:clear_flags, :hide]
  before_action :require_moderator_or_admin, only: [:flag]
  before_action :find_post, only: [:show, :edit, :update, :vote, :flag, :clear_flags, :hide]
  before_action :require_current_user_or_admin, only: [:edit, :update]

  def index
    # Move
    @items_per_page = 3
    @offset = (params[:page].to_i - 1) * @items_per_page

    # Temporarily put posts in order to check pagination
    @posts = Post.includes(:categories, :creator)
    #@posts = Post.includes(:categories, :creator).votes_created_desc.limit(@items_per_page).offset(@offset)

    # Move to helper or something
    @total_pages = Post.all.count / @items_per_page
    @total_pages += 1 if Post.all.count % @items_per_page > 0
    @num_of_page_links = 10
    @current_page = params[:page].to_i || 1
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
      @post.categories.each { |category| category.update(unhidden_posts_count: category.unhidden_posts_count += 1) }
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
    submitted_vote = params[:vote] == 'true' ? true : false

    Post.transaction do
      # @post.flagged? case may be better implemented with a around_action
      if @post.flagged? # In Flagable
        @error_msg = "You may not vote on a post that has been flagged for review."
      elsif @vote.new_record?
        @vote.vote = submitted_vote
        @vote.save
      elsif @vote.persisted? && @vote.vote == !submitted_vote
        @vote.update(vote: submitted_vote)
      elsif @vote.persisted? && @vote.vote == submitted_vote
        @error_msg = "You've already voted on this post."
      else
        @error_msg = "Sorry, your vote couldn't be counted."
      end

      @post.calculate_tallied_votes # Voteable
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
      format.js { render 'shared/flag', locals: { obj: @post.reload } }
    end
  end

  def clear_flags
    Post.transaction do
      @post.flags.each { |flag| flag.destroy }
      @post.update(total_flags: 0)
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'shared/update_admin_flagged', locals: { obj: @post } }
    end
  end

  def hide
    Post.transaction do
      @post.update(hidden: true)
      @post.votes.each { |vote| vote.destroy }
      @post.flags.each { |flag| flag.destroy }
      @post.comments.each do |comment|
        comment.votes.each { |vote| vote.destroy }
        comment.flags.each { |flag| flag.destroy }
        comment.update(hidden: true)
      end
      @post.categories.each { |category| category.update(unhidden_posts_count: category.unhidden_posts_count -= 1) }
    end

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
      if @post.creator != current_user && !current_user.admin?
        flash[:danger] = "Access Denied! - You may only edit posts that you've created."
        redirect_to @post
      end
    end

    def post_params
      params.require(:post).permit(:title, :url, :description, :category_ids => [])
    end

end
