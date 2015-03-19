class PostsController < ApplicationController
  def index
    @posts = Post.includes(:creator, :categories, :comments)
  end

  def show
    @post = Post.find(params[:id])
  end
end
