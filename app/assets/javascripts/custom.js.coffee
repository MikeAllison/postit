$ ->
  adjustStyles()
  $(window).resize(adjustStyles)
  showFlaggedItemMsgs()
  checkPasswordInput()
  $("#user_password").keyup(checkPasswordInput)

  # Enable Bootstrap tooltips
  $('[data-toggle="tooltip"]').tooltip()

# Toggles between Bootstrap Pills and the normal nav CSS styles/classes based on window size
# Adds .btn-lg to the non-mobile post voting button links
adjustStyles = ->
  window_width = $(window).width()
  ul_navbar_links = $("ul#navbar-links")

  # Remove both navbar classes on page load
  ul_navbar_links.removeClass("nav-pills navbar-default")

  # Use pills for nav links on screens >= 750
  # Use Bootstrap responsive menu on screens < 750
  # Needs to be set to 747 to fix a display issue
  if window_width >= 747
    ul_navbar_links.addClass("nav-pills")
    $(".post-voting a").addClass("btn-lg")
  else
    ul_navbar_links.addClass("navbar-default")

# Shows each h4 .flagged-item-msg if it contains a message
showFlaggedItemMsgs = ->
  $('.flagged-item-msg').each ->
    $(this).show() if $(this).text().length != 0

# Checks to see if password box in users/form has a value
checkPasswordInput = ->
  password = $("#user_password")
  password_confirm = $("#user_password_confirmation")

  if password.val()
    password_confirm.prop("disabled", false)
  else
    password_confirm.val(null)
    password_confirm.prop("disabled", true)
