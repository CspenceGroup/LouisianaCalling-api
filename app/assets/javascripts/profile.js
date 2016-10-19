'use strict';
$(document).on('turbolinks:load', function(){
  /****************************************
   *             PROFILE                  *
   ****************************************/

  // # Profile page
  // Click to seemore button
  $('#profileSeeMore').click(function() {
    var _loading, _seeMore, last_id;
    _seeMore = $(this);
    _loading = $('#loading-gif');
    _seeMore.hide();
    _loading.show();
    last_id = $('.more-stories__details').last().attr('data-id');
    $.ajax({
      type: 'GET',
      url: 'profiles/get-more',
      data: {
        id: last_id
      },
      success: function(response) {
        var _id;
        _loading.hide();
        $('#moreStories').append(response);
        _id = $('.more-stories__details').last().attr('data-id');
        if (_id - last_id === 3) {
          _seeMore.show();
        }
      },
      error: function(response) {
        console.log(response);
      }
    });
  });
});
