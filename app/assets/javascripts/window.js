// Force the user to sign out before leaving the page.
$(document).ready(function() {

  window.onbeforeunload = function() {
    if (window.location.pathname === "/") {
      $.get('/users/sign_out');
      return "Signed out..."
    }
  };
});
