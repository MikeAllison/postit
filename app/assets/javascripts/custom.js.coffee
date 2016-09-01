$ ->
  adjustStyles()
  $(window).resize(adjustStyles)
  showFlaggedItemMsgs()
  checkPasswordInput()
  $("#user_password").keyup(checkPasswordInput)

  # Enable Bootstrap tooltips
  $('[data-toggle="tooltip"]').tooltip()

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
