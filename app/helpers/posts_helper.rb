module PostsHelper

  # Show 'New Post' button in shared/category_selection if logged in
  def new_post_button
    link_to 'New Post', new_post_path, class: 'btn btn-lg btn-primary' unless !logged_in? || @posts.empty?
  end

  def post_url(post)
    if !post.flagged? || (logged_in? && current_user.moderator? && !post.flagged_by?(current_user)) || admin_flags_index?
      raw "<blockquote><p>#{link_to post.url, post.url}</p></blockquote>"
    end
  end

  def post_description(post)
    if !post.flagged? || (logged_in? && current_user.moderator? && !post.flagged_by?(current_user)) || admin_flags_index?
      post.description
    end
  end

  # Shows a button with the post's total comments
  def comments_link(post)
    link_to post, class: 'btn btn-primary btn-xs' do
      raw "<span class='badge'>#{post.comments_count}</span> Comments"
    end unless posts_show?
  end

  # Show comment form on posts#show page if logged in
  def comments_form(post)
    render 'comments/form' if logged_in? && !post.flagged?
  end

  # Show link to edit post if current_user is the creator of the post
  def edit_post_link(obj)
    if logged_in? && (obj.creator == current_user || current_user.admin?)
      link_to edit_post_path(obj), title: 'Edit Post' do
        content_tag :small do
          content_tag :span, '', class: 'glyphicon glyphicon-pencil', :'aria-hidden' => true
        end
      end
    end
  end

end
