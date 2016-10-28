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

    target = target.slice(1);
    changeURL('About us', 'abouts?tab=' + target);
  })

  $('.faq-contact-btn').on('click', function(e) {
    e.preventDefault();
    // Hidden alert info
    $('.about-contact-container').find('.alert').hide();
    $('#about-tabs a[href="#contact-us"]').tab('show');
    changeURL('About us', 'abouts?tab=contact-us');
    $('body').scrollTop(0);
  });

  $('#faq-footer').on('click', function(e) {
    e.preventDefault();

    // Currently, About us page
    if (window.location.pathname.indexOf('abouts') != -1) {
      $('#about-tabs a[href="#faq"]').tab('show');
      changeURL('About us', 'abouts?tab=faq')
      $('body').scrollTop(0);
    } else {
      // Goto About us page with FAQ tab
      window.location.href = '/abouts?tab=faq'
      $('body').scrollTop(0);
    }
  });

  $('#contact-footer').on('click', function(e) {
    e.preventDefault();

    // Currently, About us page
    if (window.location.pathname.indexOf('abouts') != -1) {
      $('#about-tabs a[href="#contact-us"]').tab('show');
      changeURL('About us', 'abouts?tab=contact-us')
      $('body').scrollTop(0);
    } else {
      // Goto About us page with contact-us tab
      window.location.href = '/abouts?tab=contact-us'
      $('body').scrollTop(0);
    }
  });

  /*
   * Transfering to category or question which use want to move to.
   */
  $('#category-list-items a, .about-faq__topic-list a').click(function(e) {
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

  $('#faqSeeMore').on('click', function() {
    var limit = $(this).data('limit'),
      size = $("#faq-search-results").find('.faq-result-item.active').size(),
      count = $(this).data('count');

    limit = limit + size;

    $("#faq-search-results").find('.faq-result-item:lt(' + limit + ')').addClass('active');

    if(limit >= count) {
      $('.faq-see-more').hide();
    }
  });

  /*Show validation messages contact us form*/
  $('#aboutHelpForm').submit(function(event) {
    event.preventDefault();

    var target = event.target,
        email = $.trim(target[0].value),
        subject = $.trim(target[1].value),
        message = $.trim(target[2].value);

    if (!email) {
      $('.alert-danger-email').show();
    } else {
      $('.alert-danger-email').hide();
    }

    if (!subject) {
      $('.alert-danger-subject').show();
    } else {
      $('.alert-danger-subject').hide();
    }

    if (!message) {
      $('.alert-danger-message').show();
    } else {
      $('.alert-danger-message').hide();
    }

    if (email && subject && message) {
      target.submit();
    }
  });

  /*Check validation require keyworks faq*/
  $('#searchFaq').submit(function(event) {
    event.preventDefault();

    var target = event.target,
        keyWord = $.trim(target[0].value);

    if(!keyWord) {
      $('.about-faq__search').addClass('about-faq-error');
    } else {
      $('.about-faq__search').removeClass('about-faq-error');
      target.submit();
    }
  });

});
