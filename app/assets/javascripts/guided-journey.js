'use strict';
$(document).on('turbolinks:load', function(){
  /****************************************
   *             GUIDED JOURNEY                 *
   ****************************************/

  /**
   * This function handle the steps when user click on next step or back
   * @return void
   */
  $("#form-progressbar").steps({
    headerTag: "h2",
    bodyTag: "fieldset",
    autoFocus: false,
    enableAllSteps: false,
    onStepChanged: function(event, currentIndex, priorIndex) {
      if (currentIndex < priorIndex) {
        for (var idx = priorIndex; idx > currentIndex ; idx--) {
          $(event.target).find("li:eq(" + idx + ")").addClass('disabled').removeClass('done');
        }
      }

      if (currentIndex == 3) {

        /*Show button start over and hide button back, next when step is result*/
        $('.sidebar-steps-result__btn')
          .addClass('sidebar-steps-result__btn-back sidebar-steps-result__btn-next');
        $('.btn-step-start').show();

        /*Start over step when click button start over*/
        $('.btn-step-start').on('click', function() {
          $("#form-progressbar a[href='#form-progressbar-h-0']").trigger('click');
          resetAllStep();
        });

        // Set default limit/offset
        $('#searchLimit').val(10);
        $('#searchOffset').val(0);
        filterGuidedJourney(false);
      }
      else if(currentIndex === 0) {

        /*Show button next and hide button back when step is interest*/
        $('.sidebar-steps-result__btn')
          .removeClass('sidebar-steps-result__btn-back')
          .addClass('sidebar-steps-result__btn-next');
        $('.btn-step-start').hide();
      }
      else {
        /*Show button back and next when step is diffent interest and result*/
        $('.sidebar-steps-result__btn')
          .removeClass('sidebar-steps-result__btn-next sidebar-steps-result__btn-back');
        $('.btn-step-start').hide();
      }

    }
  });

  /*Click button next and back step*/
  $('.btn-step').on('click', function(e){
    var value = $(e.target).attr('value');
    $("#form-progressbar a[href='#"+value+"']").trigger('click');
  });

  var contentStep = $('.sidebar-steps-result__content'),
      contentInterest = contentStep.find('.sidebar-steps-result__content-interest'),
      contentRegion = contentStep.find('.sidebar-steps-result__content-region'),
      contentEducation = contentStep.find('.sidebar-steps-result__content-education');

  /**
   * This function handle the action when user click on region map
   * @return void
   */

  $('.guided-journey-map path, .guided-journey-map text').click(function (event) {
    var $this = $(this);

    // Check click into text
    if (event.currentTarget.tagName == 'text') {
      var pathId = '#' + event.currentTarget.getAttribute('name');

      $this = $(pathId);
    }

    var value = $this.attr('id'),
        regionContent = $('.sidebar-steps-result__content-region'),
        $selector = 'text[name=' + value +']';

    // Convert ID to region name
    value = convertToRegionName(value);

    // Check click Lafayette region
    if ($this.hasClass('lafayette')) {
      $this = $('.lafayette');
    }

    // Check click to region selected or not
    if($(this).hasClass('active')) {

      $this.removeClass('active');
      $($selector).removeClass('active');
      $('.sidebar-steps-result__content-region p[title="' + value + '"]').remove();
      $('.sidebar-steps-result__content-region').show();
      checkResultStep(contentRegion);
    } else {

      $this.addClass('active');
      $($selector).addClass('active');
      regionContent.append('<p title="' + value + '">'+ value + '</p>');
      $('.sidebar-steps-result__content-region').show();
      checkResultStep(contentRegion);
    }
  });

  /**
   * This function handle the action when user click on item interest
   * @return void
   */

  $('.interest-item').on('click', function(event) {
    var value = $(this).find('p').attr('title'),
        interestContent = $('.sidebar-steps-result__content-interest');

    /*Check item in step interest when selected and unselected*/
    if($(this).hasClass('interest')) {

      $(this).removeClass('interest').addClass('interest-active');
      interestContent.append('<p title="' + value + '">'+ value + '</p>');

    } else {

      $(this).removeClass('interest-active').addClass('interest');
      $('.sidebar-steps-result__content-interest p[title="' + value + '"]').remove();
    }

    /*Check content interest in side bar left have value or not*/
    checkResultStep(contentInterest);
  });

  /**
   * This function handle the action when user click on item education
   * @return void
   */

  $('.education-item').on('click', function(event) {
    var value = $(this).find('p').attr('title'),
        educationContent = $('.sidebar-steps-result__content-education'),
        text = 'currently in high school';

    /*Check item in step education when selected and unselected*/
    if($(this).hasClass('education')) {

      $(this).removeClass('education').addClass('education-active');
      educationContent.append('<p title="' + value + '">'+ value + '</p>');
    } else {

      $(this).removeClass('education-active').addClass('education');
      $('.sidebar-steps-result__content-education p[title="' + value + '"]').remove();
    }

    /*Check content education in side bar left have value or not*/
    checkResultStep(contentEducation);
 
    if (value.toLowerCase() === text) {
      $('.jump-start-guide').toggleClass("jump-start-inactive");
    }

  });

  /**
   * This function request url when filter by item in step
   * @return void
   */
  function getCareerResults(data, isSeeMore) {
    $('.indicator-loading-step').show();

    $.ajax({
      url : '/guided_journey/search',
      type : "get",
      dateType:"text",
      traditional: true,
      data : data,
      success: function(response) {
        // Update limit/offset
        $('#searchLimit').val(response.limit);
        $('#searchOffset').val(response.offset);

        if (response.careers.length == 0) {
          $('p.no-result-found').show();
        } else {
          $('p.no-result-found').hide();
        }

        if (isSeeMore) {
          $('#guided-search-results').append(response.careers);
        } else {
          $('#guided-search-results').html(response.careers);
        }

        //Check condition have see more
        if(response.is_see_more) {
          $('.see-more-result-step').show();
        } else {
          $('.see-more-result-step').hide();
        }

        //Hide indicator when reponse success
        $('.indicator-loading-see-more').hide();
        $('.indicator-loading-step').hide();

        //Apply lazy load for image
        $("img.lazy-load").lazyload({
          event : "timeout"
        });

        var timeout = setTimeout(function() {
          $("img.lazy-load").trigger("timeout");
        }, 200);
      },
      error: function() {

      }
    });
  }

  /* Click see more button when view more result */
  $('#see-more-result-step').click(function() {
    $(this).hide();
    $('.indicator-loading-see-more').show();
    filterGuidedJourney(true);
    $('.indicator-loading-step').hide();
  });


  function filterGuidedJourney(isSeeMore) {
    // Get career search results
    //
    var interests = [],
      educations = [],
      regions = [];

    $('.interest-item.interest-active').each(function() {
      interests.push($(this).data('interest').id);
    });

    $('.education-item.education-active').each(function() {
      educations.push($(this).data('education').id);
    });

    $('.guided-journey-map path.active').each(function() {
      regions.push(convertToRegionName($(this).attr('id')));
    });

    var params = {
      interests: interests.length > 0 ? interests.join(', ') : null,
      educations: educations.length > 0 ? educations.join(', ') : null,
      regions: regions.length > 0 ? regions.join(', ') : null,
      limit: $('#searchLimit').val(),
      offset: $('#searchOffset').val()
    };

    getCareerResults(params, isSeeMore)
  }

  checkResultStep(contentInterest);
  checkResultStep(contentRegion);
  checkResultStep(contentEducation);

  /* Check result step and show, hide valude in side bar step*/
  function checkResultStep(value) {
    if(!value.has('p').length) {
      $(value).hide();
    } else {
      $(value).show();
    }
  }

  /*Reset all step when click start over*/
  function resetAllStep(){
    $('.guided-form__interest .interest-item.interest-active').removeClass('interest-active').addClass('interest');
    $('.sidebar-steps-result__content-details').hide();
    $('.sidebar-steps-result__content-details p[title]').remove();
    $('.guided-journey-map path.active, .guided-journey-map text.active').removeClass('active');
    $('.guided-form__interest .education-item.education-active').removeClass('education-active').addClass('education');
  }
});
