$ ->
  adjustNavStyles()
  $(window).resize(adjustNavStyles)
  checkPasswordInput()
  $("#user_password").keyup(checkPasswordInput)

# Toggles between Bootstrap Pills and the normal nav CSS styles/classes based on window size
adjustNavStyles = ->
  window_width = $(window).width()
  ul_navbar_links = $("ul#navbar-links")

  # Remove both navbar classes on page load
  ul_navbar_links.removeClass("nav-pills navbar-default")

  # Use pills for nav links on screens >= 750
  # Use Bootstrap responsive menu on screens < 750
  # Needs to be set to 747 to fix a display issue
  if window_width >= 747
    ul_navbar_links.addClass("nav-pills")
  else
    ul_navbar_links.addClass("navbar-default")

# Checks to see if password box in users/form has a value
checkPasswordInput = ->
  password = $("#user_password")
  password_confirm = $("#user_password_confirmation")

  if password.val()
    password_confirm.prop("disabled", false)
  else
    password_confirm.val(null)
    password_confirm.prop("disabled", true)
