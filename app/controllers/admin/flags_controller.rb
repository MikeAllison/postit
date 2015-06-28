class Admin::FlagsController < ApplicationController
  before_action :authenticate
  before_action :require_admin

  def index
    @posts = Post.flagged
    @comments = Comment.flagged
  end

end
