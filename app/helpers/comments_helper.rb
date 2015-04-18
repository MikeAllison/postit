module CommentsHelper

  # Appends 'on (post.title) to a comment under a user profile
  def post_link(comment)
    raw "on #{link_to(comment.post.title, comment.post)}"
  end

end
