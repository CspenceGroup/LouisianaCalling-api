'use strict';

$(document).ready(function() {

  var videoModal;

  $('.btn-play-video').on('click', function(event) {
    var buttonPlayVideo = $(event.target);
    var videoSource = buttonPlayVideo.attr('data-source');

    $('#videoModal').find('.modal-video__details').prepend(
      '<video preload autoplay class="video-playing video-player">\
        <source src=' + videoSource + ' type="video/mp4">\
      </video>\
      <div class="button-pause" style="display: none;"><i class="icon-pause"></i><div>');
  });

  $('#videoModal').on('shown.bs.modal', function (event) {
    videoModal = $(event.target);
    var buttonPause = videoModal.find('.button-pause');

    videoModal.find('video').on('click', function(e) {
      e.preventDefault();
      if(this.paused) {
        this.play();
        buttonPause.hide();
      } else {
        this.pause();
        buttonPause.show();
      }
    })
  });

  $('#videoModal').on('hide.bs.modal', function (event) {
    videoModal = $(event.target);
    if(videoModal.find('video').length > 0) {
      videoModal.find('video').remove();
    }
  });
});