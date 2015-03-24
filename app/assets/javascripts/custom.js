// Toggles between Bootstrap Pills and the normal nav CSS styles/classes based on window size
function adjustNavStyles(windowWidth) {
  var windowWidth = $(window).width();

  $("ul.nav").removeClass("nav-pills navbar-default");

  if (windowWidth >= 750) {
    $("ul.nav").addClass("nav-pills");
  } else {
    $("ul.nav").addClass("navbar-default");
  }
}
