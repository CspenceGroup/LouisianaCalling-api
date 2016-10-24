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

});
