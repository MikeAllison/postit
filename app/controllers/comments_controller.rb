class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = User.first # Remove later

    if @comment.save
      flash[:success] + "Your comment was added."
      redirect_to @post
    else
      redirect_to post_path(@post)
    end
  end
end
