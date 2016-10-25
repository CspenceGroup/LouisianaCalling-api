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
    onStepChanged: function (event, currentIndex, priorIndex) {
      if (currentIndex < priorIndex){
        $(event.target).find("li:eq("+priorIndex+")").removeClass('done');
      }
    }
  });

  $('.btn-step').on('click', function(e){
    var value = $(e.target).attr('value');
    $("#form-progressbar [href='#"+value+"']").trigger('click');
  });

  $(".item-step-title").dotdotdot({});

  /**
   * This function handle the action when user click on region map
   * @return void
   */

  $('.guided-journey-map path').click(function (e) {

    var value = $(this).attr('id'),
        regionContent = $('.sidebar-steps-result__content-region');

    /**
     * Active clicked region & show top jobs in view
     */
    if($(this).hasClass('active')) {

      if($(this).hasClass('lafayette')) {

        $('.lafayette').removeClass('active');
        $('.sidebar-steps-result__content-region p[title="' + value + '"]').remove();
      } else {

        $(this).removeClass('active');
        $('.sidebar-steps-result__content-region p[title="' + value + '"]').remove();
      }
    } else {

      if($(this).hasClass('lafayette')) {

        $('.lafayette').addClass('active');
        regionContent.append('<p title="' + value + '">'+ value + '</p>');
      } else {

        $(this).addClass('active');
        regionContent.append('<p title="' + value + '">'+ value + '</p>');
      }
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
        $('#careerLimit').val(response.limit);
        $('#careerOffset').val(response.offset);

      },
      error: function() {

      }
    });
  }
});
