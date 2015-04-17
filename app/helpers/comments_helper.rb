module CommentsHelper
  def post_link(comment)
    raw "on #{link_to(comment.post.title, comment.post)}"
  end
end
