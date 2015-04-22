class PostsController < ApplicationController
  before_action :authenticate, except: [:index, :show]
  before_action :find_post, only: [:show, :edit, :update]
  before_action :restrict_post_editing, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:creator, :categories, :comments)
  end

  def new
    @post = Post.new
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

  private

    def find_post
      @post = Post.find(params[:id])
    end

    def restrict_post_editing
      if @post.creator != current_user
        flash[:danger] = "You can only edit posts that you've created."
        redirect_to @post
      end
    end

    def post_params
      params.require(:post).permit(:title, :url, :description, :category_ids => [])
    end
end
