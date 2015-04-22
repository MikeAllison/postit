module ApplicationHelper

  # Populates category selection dropdown
  def page_title
    @category.nil? ? 'All Posts' : @category.name
  end

  # Converts .created_at to a nicer format
  def formatted_date_time(obj)
    obj.created_at.strftime("on %m/%d/%Y at %l:%M %Z")
  end

  # Sets upvote/downvote buttons on posts
  # obj: post, vote: t/f, btn_size: 'btn-md/lg', glyph_type: 'thumbs-up/down', color: 'text-success/danger'
  def post_voting_button(obj, vote, btn_size, glyph_type, text_color)
    (disabled = 'disabled') && (text_color = 'text-default') if !logged_in? || obj.has_same_vote_from?(current_user, vote)

    link_to post_votes_path(obj, vote: vote), method: :post, class: "btn btn-default #{btn_size} #{disabled}", remote: true do
      content_tag :span, nil, class: "glyphicon glyphicon-#{glyph_type} #{text_color}", aria_hidden: true
    end
  end

  # Sets upvote/downvote buttons on comments
  # obj1: comment.post, obj2: comment, vote: t/f, btn_size: 'btn-md/lg', glyph_type: 'thumbs-up/down', color: 'text-success/danger'
  def comment_voting_button(obj1, obj2, vote, btn_size, glyph_type, text_color)
    (disabled = 'disabled') && (text_color = 'text-default') if !logged_in? || obj2.has_same_vote_from?(current_user, vote)

    link_to post_comment_votes_path(obj1, obj2, vote: vote), method: :post, class: "btn btn-default #{btn_size} #{disabled}", remote: true do
      content_tag :span, nil, class: "glyphicon glyphicon-#{glyph_type} #{text_color}", aria_hidden: true
    end
  end

  # Tallies votes for posts and comments
  def tally_votes(obj)
    total_votes = 0
    upvotes = obj.votes.where("vote = ?", true).count
    downvotes = obj.votes.where("vote = ?", false).count

    total_votes = upvotes - downvotes

    "#{total_votes} Votes"
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
