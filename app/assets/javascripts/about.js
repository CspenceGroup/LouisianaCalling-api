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

  $('#about-tabs a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    var target = $(e.target).attr("href"); // activated tab

    target = target.slice(1)
    changeURL('About us', 'abouts?tab=' + target)
  })

  $('.faq-contact-btn').on('click', function(e) {
    e.preventDefault();
    // Hidden alert info
    $('.about-contact-container').find('.alert').hide();
    $('#about-tabs a[href="#contact-us"]').tab('show');
    changeURL('About us', 'abouts?tab=contact-us')
  });

  $('#faq-footer').on('click', function(e) {
    e.preventDefault();

    // Currently, About us page
    if (window.location.pathname.indexOf('abouts') != -1) {
      $('#about-tabs a[href="#faq"]').tab('show');
      changeURL('About us', 'abouts?tab=faq')
    } else {
      // Goto About us page with FAQ tab
      window.location.href = '/abouts?tab=faq'
    }
  });

  $('#contact-footer').on('click', function(e) {
    e.preventDefault();

    // Currently, About us page
    if (window.location.pathname.indexOf('abouts') != -1) {
      $('#about-tabs a[href="#contact-us"]').tab('show');
      changeURL('About us', 'abouts?tab=contact-us')
    } else {
      // Goto About us page with contact-us tab
      window.location.href = '/abouts?tab=contact-us'
    }
  });

  /*
   * Transfering to category or question which use want to move to.
   */
  $('.about-faq__main-content a').click(function(e) {
    e.preventDefault();

    var hash = $(this)[0].hash;
    var parent = $(this).closest('.about-faq__main-content');

    if (hash.indexOf("-q") >= 0) {

      // Scroll to question
      var id = hash.split('-').slice(0, -1).join('-');
      var ele = $(id);
      var page = $('html, body');

      ele
        .closest('.about-faq__main-content')
        .find('.categories')
        .removeClass('category-active')
        .addClass('category-inactive');

      ele
        .removeClass('category-inactive')
        .addClass('category-active');

      page.animate({
        scrollTop: $(hash).offset().top-95
      }, 10);

    } else {
      // Move to Catogory
      parent.find('.categories')
        .removeClass('category-active')
        .addClass('category-inactive');

      parent.find(hash)
        .removeClass('category-inactive')
        .addClass('category-active');
    }
  });

  $('.faq-back').click(function(e) {
    e.preventDefault();

    var parent = $(this).closest('.about-faq__main-content');

    parent.find('.category-active')
      .removeClass('category-active')
      .addClass('category-inactive');

    // Move to Catogory
    parent.find('.categories')
      .removeClass('category-inactive')
      .addClass('category-active');
  });

  // $('.faq-input').on('blur', function() {
  //   var value = $(this).val();
  //   if(!value) {
  //     $('#faq-category-list').removeClass('category-inactive').addClass('category-active');
  //     $('#faq-search-results').hide();
  //     $('.faq-see-more').hide();
  //   }
  // });


  /*Show question result when click search question*/
  var size = $("#faq-search-results").find('.faq-result-item').size(),
      countItem = $("#faq-search-results").find('.faq-result-item').length,
      item = 5;
  $("#faq-search-results").find('.faq-result-item:lt('+item+')').show();

  $('#faqSeeMore').on('click', function() {
    item = (item+5 <= size) ? item+5 : size;
    $("#faq-search-results").find('.faq-result-item:lt('+item+')').show();
    var sizeShow = $("#faq-search-results").find('.faq-result-item:lt('+item+')').show().size();

    if(sizeShow === countItem) {
      $('.faq-see-more').hide();
    }
  });


  /*Show validation messages contact us form*/
  $('#aboutHelpForm').submit(function(event) {
    event.preventDefault();

    var target = event.target,
        email = target[0].value,
        subject = target[1].value,
        message = target[2].value;
    
    if(!email) {
      $('.alert-danger-email').show();
      $('.alert-danger-subject, .alert-danger-message').hide();
    } else if(!subject) {
      $('.alert-danger-subject').show();
      $('.alert-danger-email, .alert-danger-message').hide();
    } else if(!message) {
      $('.alert-danger-message').show();
      $('.alert-danger-email, .alert-danger-subject').hide();
    } else {
      $('.alert-danger-email, .alert-danger-subject, .alert-danger-message').hide();
      target.submit();
    }
  });

});