// Toggles between Bootstrap Pills and the normal nav CSS styles/classes based on window size
function adjustNavStyles(windowWidth) {
  var windowWidth = $(window).width();

  // Remove both navbar classes on page load
  $("ul#navbar-links").removeClass("nav-pills navbar-default");

  // Use pills for nav links on screens >= 750
  // Use Bootstrap responsive menu on screens < 750
  // Needs to be set to 747 to fix a display issue 
  if (windowWidth >= 747) {
    $("ul#navbar-links").addClass("nav-pills");
  } else {
    $("ul#navbar-links").addClass("navbar-default");
  }
}
