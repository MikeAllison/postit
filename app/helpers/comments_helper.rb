module CommentsHelper
  ### LAYOUT-RELATED HELPERS ###

  # Appends 'on (post.title)' to a comment under a user profile
  def post_link(comment)
    "on #{link_to comment.post.title, comment.post}" unless posts_show_view? # AppHelper
  end

  # Displays a comment's footer
  def comment_footer(comment)
    raw "#{link_to comment.creator.username_role, comment.creator, class: 'user-name-role'} <cite>#{formatted_date_time(comment)}</cite>"
  end

  ### FLAGGING FEATURE HELPERS ###

  # Displays comment.body unless the comment is flagged
  def comment_body(comment)
    if !comment.flagged? || flagged_by_other_user?(comment) || admin_flags_index_view?
      raw "<q>#{comment.body}</q> <em>#{post_link(comment)}</em>"
    end
  end
end
