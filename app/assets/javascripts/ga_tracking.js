'use strict';
$(document).on('turbolinks:load', function() {
  var pageview = window.location.pathname,
    title = document.title;

  if (pageview == '/abouts') {
    title = 'About Us - Louisiana Calling'
  }

  var page = {
    page: pageview,
    title: title
  };

  if (window.ga) {
    ga('send', 'pageview', page);
  }
});
