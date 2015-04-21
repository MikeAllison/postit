module ApplicationHelper

  # Populates category selection dropdown
  def page_title
    @category.nil? ? 'All Posts' : @category.name
  end

  # Converts .created_at to a nicer format
  def formatted_date_time(obj)
    obj.created_at.strftime("on %m/%d/%Y at %l:%M %Z")
  end

  # Sets upvote button on posts and comments
  def upvote_button(obj, btn_size)
    disabled = 'disabled' if !logged_in? || obj.has_vote_from?(current_user, true)

    link_to post_votes_path(obj, vote: true), method: :post, class: "btn btn-default #{btn_size} #{disabled}", remote: true do
      content_tag :span, nil, class: 'glyphicon glyphicon-thumbs-up text-success', aria_hidden: true
    end
  end

  # Sets downvote button on posts and comments
  def downvote_button(obj, btn_size)
    disabled = 'disabled' if !logged_in? || obj.has_vote_from?(current_user, false)

    link_to post_votes_path(obj, vote: false), method: :post, class: "btn btn-default #{btn_size} #{disabled}", remote: true do
      content_tag :span, nil, class: 'glyphicon glyphicon-thumbs-down text-danger', aria_hidden: true
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
