class PostsController < ApplicationController
  def index
    @posts = Post.all

    # This is probably wrong
    @categories = Category.all
  end

  def show
    @post = Post.find(params[:id])
  end
end
