// Override the default confirm dialog box in Rails

// If data-confirm doesn't have a value in link_to, return
// If it does have a value, call showConfirmationDialog
$.rails.allowAction = function(link) {
  if (link.data("confirm") == undefined) {
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}

// Set data-confirm to null
// Continue executing action
$.rails.confirmed = function(link) {
  link.data("confirm", null);
  link.trigger("click.rails");
}

// Display the confirmation with bootbox styling
// If 'OK' clicked (result === true), call confirmed
$.rails.showConfirmationDialog = function(link) {
  var message = link.data("confirm");
  bootbox.confirm(message, function(result) {
    if (result) {
      $.rails.confirmed(link);
    }
  });
}
