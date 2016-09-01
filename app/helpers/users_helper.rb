module UsersHelper
  # Shows appropriate icon for new user/existing user
  def user_create_update(user)
    if user.new_record?
      glyphicon_type = 'check'
      action = 'Register'
    else
      glyphicon_type = 'floppy-saved'
      action = 'Update'
    end

    glyphicon = content_tag :span, nil, class: "glyphicon glyphicon-#{glyphicon_type}", :'aria-hidden' => true
    glyphicon + " #{action}"
  end
end
