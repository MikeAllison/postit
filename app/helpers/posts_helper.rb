module PostsHelper
  ### LAYOUT-RELATED HELPERS ###

  # Show 'New Post' button in shared/category_selection if logged in
  def new_post_button
    glyphicon = content_tag :span, '', class: 'glyphicon glyphicon-file', :'aria-hidden' => true
    link_to new_post_path, class: 'btn btn-primary btn-lg' do
      glyphicon + ' New Post'
    end unless !logged_in? || @posts.empty?
  end

  # Shows appropriate icon for new post/existing post
  def post_create_update(post)
    action =  post.new_record? ? 'Create Post' : 'Update Post'

    glyphicon = content_tag :span, nil, class: 'glyphicon glyphicon-floppy-saved', :'aria-hidden' => true
    glyphicon + " #{action}"
  end

  def new_category_link
    link_to '(Add a Category)', new_admin_category_path, class: 'small' if current_user.admin?
  end

  # Shows a button with the post's total comments
  def comments_link(post)
    link_to post, class: 'btn btn-primary btn-xs comments-btn' do
      raw "<span class='badge'>#{post.unhidden_comments_count}</span> Comments"
    end unless posts_show_view?
  end

  # Show comment form on posts#show page if logged in
  def comments_form(post)
    render 'comments/form' if logged_in? && !post.flagged?
  end

  # Show link to edit post if current_user is the creator of the post
  def edit_post_link(obj)
    if logged_in? && (obj.creator == current_user || current_user.admin?)
      link_to edit_post_path(obj), title: 'Edit Post', :'data-toggle' => 'tooltip' do
        content_tag :small do
          content_tag :span, '', class: 'glyphicon glyphicon-pencil', :'aria-hidden' => true
        end
      end
    end
  end

  ### FLAGGING FEATURE HELPERS ###

  def post_url(post)
    if !post.flagged? || flagged_by_other_user?(post) || admin_flags_index_view?
      raw "<blockquote><p>#{link_to post.url, post.url}</p></blockquote>"
    end
  end

  def post_description(post)
    if !post.flagged? || flagged_by_other_user?(post) || admin_flags_index_view?
      post.description
    end
  end
end
