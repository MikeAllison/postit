module ApplicationHelper

  ### CONTROLLER/ACTION HELPERS ###

  def posts_show_view?
    controller_name == 'posts' && action_name == 'show'
  end

  def admin_flags_index_view?
    controller_name == 'flags' && action_name == 'index'
  end

  ### NAVBAR HELPERS ###

  # Sets 'Register' or options for logged in user on navbar
  def user_options_link
    if logged_in?
      render 'layouts/user_menu'
    else
      link_to 'Register', register_path, class: 'text-muted', data: { no_turbolink: true }
    end
  end

  # Sets 'Login/Logout' link on navbar
  def login_link
    if logged_in?
      link_to 'Log Out', logout_path, class: 'text-muted'
    else
      link_to 'Log In', login_path, class: 'text-muted'
    end
  end

  ### LAYOUT-RELATED HELPERS ###

  # Sets glyphicon in flash messages
  def glyphicon(type)
    if type == 'danger'
      glyph_type = 'exclamation'
    elsif type == 'success'
      glyph_type = 'ok'
    else
      glyph_type = 'info'
    end

    content_tag :span, nil, class: "glyphicon glyphicon-#{glyph_type}-sign", :'aria-hidden' => true
  end

  # Populates category selection dropdown
  def category_title
    @category.nil? ? 'All Posts' : "#{@category.name} (#{@category.posts_count})"
  end

  # Converts .created_at to a nicer format
  def formatted_date_time(obj)
    obj.created_at.strftime("on %m/%d/%Y at %l:%M %Z")
  end

  ### VOTING FEATURE HELPERS ###

  # Sets upvote/downvote buttons on posts/comments
  # obj: post/comment, vote: t/f, glyph_type: 'thumbs-up/down', color: 'text-primary/danger'
  # .vote_exists? in Voteable
  def voting_button(obj, vote, glyph_type, text_color)
    (disabled = 'disabled') && (text_color = 'text-default') if !logged_in? || obj.vote_exists?(current_user, vote) || obj.flagged?

    link_to [:vote, obj, vote: vote], method: :post, class: "btn btn-default #{disabled}", remote: true do
      content_tag :span, nil, class: "glyphicon glyphicon-#{glyph_type} #{text_color}", :'aria-hidden' => true
    end
  end

  ### FLAGGING FEATURE HELPERS ###

  def flagged_posts_count
    Post.flagged.count
  end

  def flagged_comments_count
    Comment.flagged.count
  end

  def flagged_items_count
    flagged_posts_count + flagged_comments_count
  end

  def flagged_by_current_user?(obj)
    logged_in? && current_user.moderator? && obj.flagged_by?(current_user)
  end

  def flagged_by_other_user?(obj)
    logged_in? && current_user.moderator? && !obj.flagged_by?(current_user)
  end

  # Displays a message if the object is flagged
  def flagged_item_msg(obj)
    if obj.flagged? && !admin_flags_index_view?
      glyphicon = content_tag :span, nil, class: 'glyphicon glyphicon-alert', :'aria-hidden' => true

      ending = flagged_by_current_user?(obj) ? "by you" : "for review by a moderator"

      raw "#{glyphicon} <em>This #{obj.class.to_s.downcase}'s content has been flagged #{ending}.</em>"
    end
  end

  # Sets links for moderators to flag posts or comments
  def flag_item_btn(obj)
    if logged_in? && current_user.moderator?
      if obj.flagged_by?(current_user) # In Flagable
        link_to "Unflag #{obj.class}", [:flag, obj, flag: false], method: :post, class: 'btn btn-success btn-xs', remote: true
      else
        link_to "Flag #{obj.class}", [:flag, obj, flag: true], method: :post, class: 'btn btn-danger btn-xs', remote: true
      end
    end
  end

  ### ADMIN FLAGGING FEATURE HELPERS ###

  # Button for admins to hide posts/comments
  def hide_item_btn(obj)
    if logged_in? && current_user.admin? && admin_flags_index_view?
      link_to 'Hide Item', [:hide, obj], method: :post, class: 'btn btn-default btn-xs hide-item-btn', remote: true, data: { confirm: "Are you sure that this item should be permanently hidden?" }
    end
  end

  # Button for admins to clear all flags on a post/comment
  def clear_flags_btn(obj)
    if logged_in? && current_user.admin? && admin_flags_index_view?
      link_to [:clear_flags, obj], method: :post, class: 'btn btn-success btn-xs', remote: true do
        raw "Clear Flags <span class='badge'>#{obj.flags_count}</span>"
      end
    end
  end

end
