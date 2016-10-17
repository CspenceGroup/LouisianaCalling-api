'use strict';
$(document).on('turbolinks:load', function(){
  /****************************************
   *             About                  *
   ****************************************/
  var changeURL = function(page, url) {
    if (typeof(history.pushState) != 'undefined') {
      var obj = { page: page, url: url };
      history.pushState(obj, page, url);
    } else {
      console.log("Browser does not support HTML5.");
    }
  };

  $( document ).ready(function() {
    if (window.location.pathname.indexOf('abouts') != -1) {
      changeURL('About us', 'abouts')
    }
  });

  $('.faq-contact-btn').on('click', function(e) {
    e.preventDefault();
    // Hidden alert info
    $('.about-contact-container').find('.alert').hide();
    $('#about-tabs a[href="#contactUs"]').tab('show');
  });

  $('#faq-footer').on('click', function(e) {
    e.preventDefault();

    // Currently, About us page
    if (window.location.pathname.indexOf('abouts') != -1) {
      $('#about-tabs a[href="#faq"]').tab('show');
    } else {
      // Goto About us page with FAQ tab
      window.location.href = '/abouts?tab=faq'
    }
  });

  $('#contact-footer').on('click', function(e) {
    e.preventDefault();

    // Currently, About us page
    if (window.location.pathname.indexOf('abouts') != -1) {
      $('#about-tabs a[href="#contactUs"]').tab('show');
    } else {
      // Goto About us page with contact-us tab
      window.location.href = '/abouts?tab=contact-us'
    }
  });
});
