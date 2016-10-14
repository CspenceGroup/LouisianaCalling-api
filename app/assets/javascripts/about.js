'use strict';
$(document).on('turbolinks:load', function(){
  /****************************************
   *             About                  *
   ****************************************/

  $('.faq-contact-btn').on('click', function() {
    $('#about-tabs a[href="#contactUs"]').tab('show');
  });

  $('#faq-footer').on('click', function(e) {
    e.preventDefault();
    $('#about-tabs a[href="#faq"]').tab('show');
  });

  $('#contact-footer').on('click', function(e) {
    e.preventDefault();
    $('#about-tabs a[href="#contactUs"]').tab('show');
  });
});
