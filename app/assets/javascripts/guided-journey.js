'use strict';
$(document).on('turbolinks:load', function(){
  /****************************************
   *             GUIDED JOURNEY                 *
   ****************************************/

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

  /**
   * This function handle the action when user click on region map
   * @return void
   */
  
  $('.guided-journey-map path').click(function (e) {

    /**
     * Active clicked region & show top jobs in view
     */
    if($(this).hasClass('active')) {

      if($(this).hasClass('lafayette')) {

        $('.lafayette').removeClass('active');
      } else {

        $(this).removeClass('active');
      }
    } else {
      
      if($(this).hasClass('lafayette')) {

        $('.lafayette').addClass('active');
      } else {

        $(this).addClass('active');
      }
    }

    
  });

});
