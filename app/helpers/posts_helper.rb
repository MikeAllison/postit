module PostsHelper

  # Show 'New Post' button in shared/page_title if logged in
  def new_post_button
    link_to 'New Post', new_post_path, class: 'btn btn-lg btn-primary' if logged_in?
  end

  # Show comment form on posts#show page if logged in
  def comments_form
    render 'comments/form' if logged_in?
  end

  # Show link to edit post if current_user is the creator of the post
  def edit_post_link(obj)
    if obj.creator == current_user
      link_to edit_post_path(obj), title: 'Edit Post' do
        content_tag :small do
          content_tag :span, '', class: 'glyphicon glyphicon-pencil', aria_hidden: true
        end
      end
    end
  end

end
