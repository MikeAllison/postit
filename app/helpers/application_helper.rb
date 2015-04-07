module ApplicationHelper

  # Populates category selection dropdown
  def page_title
    @category.nil? ? 'All Posts' : @category.name
  end

  # Converts .created_at to a nicer format
  def formatted_date_time(obj)
    obj.created_at.strftime("on %m/%d/%Y at %l:%M %Z")
  end

  # Tallies votes for posts and comments
  def tally_votes
    "# Votes"
  end

  # Sets 'Login/Logout' link on nav bar
  def login_link
    if current_user
      link_to "Log Out", logout_path, class: 'text-muted'
    else
      link_to "Log In", login_path, class: 'text-muted'
    end
  end

end
