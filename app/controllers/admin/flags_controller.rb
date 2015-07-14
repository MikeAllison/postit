class Admin::FlagsController < ApplicationController
  before_action :authenticate
  before_action :require_admin

  def index
    @posts = Post.includes(:categories, :creator).flagged_desc
    @comments = Comment.includes(:post, :creator).flagged_desc
  end

end
