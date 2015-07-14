class Admin::FlagsController < ApplicationController
  before_action :authenticate
  before_action :require_admin

  def index
    @posts = Post.flagged_desc
    @comments = Comment.flagged_desc
  end

end
