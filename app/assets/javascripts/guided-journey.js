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
    onStepChanged: function(event, currentIndex, newIndex) {
      $(event.target).find("li").removeClass('done');
    },
    onStepChanging: function (event, currentIndex, newIndex) {
      if (newIndex == 3) {
        // Get career search results
        //
        var interests = [],
          educations = [];

        $('.interest-item.interest-active').each(function() {
          interests.push(this.data('interest').id);
        });

        $('.education-item.education-active').each(function() {
          educations.push(this.data('education').id);
        });

        var params = {
          interests: interests.length > 0 ? interests.join(', ') : null,
          educations: educations.length > 0 ? educations.join(', ') : null
        };

        getCareerResults(params)
      }
      return true;
    }
  });

  $('.btn-step').on('click', function(e){
    var value = $(e.target).attr('value');
    $("#form-progressbar a[href='#"+value+"']").trigger('click');
  });


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
        $('#searchLimit').val(response.limit);
        $('#searchOffset').val(response.offset);
        $('#guided-search-results').append(response.careers);
      },
      error: function() {

      }
    });
  }
});
