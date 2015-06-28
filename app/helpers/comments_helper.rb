module CommentsHelper

  # Appends 'on (post.title)' to a comment under a user profile
  def post_link(comment)
    "on #{link_to comment.post.title, comment.post}" unless posts_show? # AppHelper
  end

  # Displays comment.body unless the comment is flagged
  def comment_body(comment)
    if admin_flags_index? || !comment.flagged?
      raw "<q>#{comment.body}</q> <em>#{post_link(comment)}</em>"
    end
  end

  # Displays a comment's footer
  def comment_footer(comment)
    raw "#{link_to comment.creator.username_role, comment.creator, class: 'user-name-role'} <cite>#{formatted_date_time(comment)}</cite>"
  end

end
