// Override the default confirm dialog box in Rails

// If data-confirm doesn't have a vaule in link_to...return
// If it does have a value, call showConfirmationDialog
$.rails.allowAction = function(link) {
  if (link.data("confirm") == undefined) {
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}

// If confirm button is clicked:
// 1. Set data-confirm to null
// 2. Continue executing action
$.rails.confirmed = function(link) {
  link.data("confirm", null);
  link.trigger("click.rails");
}

// Display the confirmation with bootbox styling
// If result === true, call confirmed
$.rails.showConfirmationDialog = function(link) {
  var message = link.data("confirm");
  bootbox.confirm(message, function(result) {
    if (result) {
      $.rails.confirmed(link);
    }
  });
}
