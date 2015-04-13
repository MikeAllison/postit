module CommentsHelper
  def post_link(comment)
    raw "on #{link_to(comment.post.title, post_path(comment.post))}"
  end
end
