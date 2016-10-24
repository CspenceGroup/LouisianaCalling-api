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


  //Show popup video when click button play
  $('#videoProfileModal').on('shown.bs.modal', function(event) {

    $('#video-profile')[0].play();
  }).on('hide.bs.modal', function() {

    $('#video-profile')[0].pause();
    $('#btn-profile-pause').hide();
  });

  $('#video-profile').on('click', function(e) {
    e.preventDefault();

    var btnPause = $('#btn-profile-pause');

    if(this.paused) {

      this.play();
      btnPause.hide();
    } else {

      this.pause();
      btnPause.show();
    }
  }).on('ended', function() {

    $('#videoProfileModal').modal('hide');
  });

  $('#profile-video-content').on('click', function(e) {
    if (e.target !== this) {
      return;
    }

    $('#videoProfileModal').modal('hide');
  });

});
