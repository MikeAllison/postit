module ApplicationHelper

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

  # Sets upvote/downvote buttons on posts/comments
  # obj: post/comment, vote: t/f, btn_size: 'btn-md/lg', glyph_type: 'thumbs-up/down', color: 'text-primary/danger'
  # .vote_exists? in Voteable
  def voting_button(obj, vote, btn_size, glyph_type, text_color)
    (disabled = 'disabled') && (text_color = 'text-default') if !logged_in? || obj.vote_exists?(current_user, vote)

    link_to [:vote, obj, vote: vote], method: :post, class: "btn btn-default #{btn_size} #{disabled}", remote: true do
      content_tag :span, nil, class: "glyphicon glyphicon-#{glyph_type} #{text_color}", :'aria-hidden' => true
    end
  end

  # Sets 'Register' or options for logged in user on navbar
  def user_options_link
    if logged_in?
      render 'layouts/user_options_menu'
    else
      link_to 'Register', register_path, class: 'text-muted'
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

end
