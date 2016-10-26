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
    autoFocus: true,
    onStepChanged: function(event, currentIndex, priorIndex) {
      if (currentIndex < priorIndex) {
        for (var idx = priorIndex; idx > currentIndex ; idx--) {
          $(event.target).find("li:eq(" + idx + ")").removeClass('done');
        }
      }
      console.log('currentIndex:', currentIndex);

      if (currentIndex == 3) {
        // Set default limit/offset
        $('#searchLimit').val(9);
        $('#searchOffset').val(0);
        filterGuidedJourney();
      }
    }
  });

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

    if($(this).hasClass('interest')) {

      $(this).removeClass('interest').addClass('interest-active');
      interestContent.append('<p title="' + value + '">'+ value + '</p>');

    } else {

      $(this).removeClass('interest-active').addClass('interest');
      $('.sidebar-steps-result__content-interest p[title="' + value + '"]').remove();
    }

    $('.sidebar-steps-result__content-interest').show();
    checkResultStep(contentInterest);
  });

  /**
   * This function handle the action when user click on item education
   * @return void
   */

  $('.education-item').on('click', function(event) {
    var value = $(this).find('p').attr('title'),
        educationContent = $('.sidebar-steps-result__content-education');

    if($(this).hasClass('education')) {

      $(this).removeClass('education').addClass('education-active');
      educationContent.append('<p title="' + value + '">'+ value + '</p>');
    } else {

      $(this).removeClass('education-active').addClass('education');
      $('.sidebar-steps-result__content-education p[title="' + value + '"]').remove();
    }

    $('.sidebar-steps-result__content-education').show();
    checkResultStep(contentEducation);
  });

  function getCareerResults(data) {
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
        $('#guided-search-results').append(response.careers);

        if(response.is_see_more) {
          $('.see-more-result-step').show();
        } else {
          $('.see-more-result-step').hide();
        }

        $('.indicator-loading-see-more').hide();
        
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

  $('#see-more-result-step').click(function() {
    $('.indicator-loading-see-more').show();
    $(this).hide();
    filterGuidedJourney();
  });

  function filterGuidedJourney() {
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
      regions: regions.length > 0 ? regions.join(', ') : null
    };

    getCareerResults(params)
  }

  checkResultStep(contentInterest);
  checkResultStep(contentRegion);
  checkResultStep(contentEducation);

  function checkResultStep(value) {
    if(!value.has('p').length) {
      $(value).hide();
    } else {
      $(value).show();
    }
  }
});
