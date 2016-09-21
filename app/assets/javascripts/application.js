// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require tether
//= require bootstrap
//= require jquery_ujs
//= require turbolinks
//= require_tree .


'use strict';

$(document).on('turbolinks:load', function(){

  /**
  * Handle Data
  */

  var regions = {};
  if ($('#mapData').html()) {
    regions = JSON.parse($('#mapData').html());
  }

  /**
   * Data Mock
   */
  var careers = {
    "alexandria": {
        "job": "Boilmakers",
        "salary": "$40,000 - $50,000",
        "certificate": "High school diploma 2-year training"
      },
    "lake-charles": {
        "job": "Boilmakers",
        "salary": "$55,000 - $65,000",
        "certificate": "High school diploma 4-year training"
      }
  };

  /**
   * Init Map and Region Top Jobs
   */
  showRegionJobs();

  /**
   * Init Region Career Options Map
   */
  showRegionCareerOptions();

  /**
   * This function handle the action when user click on region map
   * @return void
   */
  $('path').click(function (e) {

    // Reset top job list
    $('#top-region-jobs').empty();
    $('#career-salary').empty();
    $('#career-certificate').empty();

    /**
     * Active clicked region & show top jobs in view
     */

    $('.top-jobs__map path').removeClass('active');

    if ($(this).hasClass('lafayette')) {

      $('.lafayette').addClass('active');
      showRegionJobs();
      showRegionCareerOptions();
    } else {

      $(this).addClass('active');
      showRegionJobs();
      showRegionCareerOptions();
    }
  });

  /**
   * COMMON FUNCTIONS
   */

  /**
   * Convert ID get from map path into Region Name
   * @param  {string} name ID of map's path
   * @return {string} Region Name after convert
   */
  function convertToRegionName (name) {
    if (name) {
      return name.split('-').join(' ');
    }

  }

  /**
   * Get Region Name from Element
   * @param  {object} ele element for getting its Id
   * @return {string}     region name after converting
   */
  function getRegionId (ele) {
    if (ele[0]) {
      return ele[0].id;
    }
  }

  /**
   * Add Region Name to Map Heading
   * @param {string} name Name of the selected region
   */
  function addRegionName (regionId) {
    var region = convertToRegionName(regionId);

    $('#region-name').text(region);
  }

  /**
   * Show Top Jobs of selected region in View
   * @param  {string} regionId Id of selected region
   * @return {void}
   */
  function showTopJobs (regionId) {
    if (regions) {
      var activeRegionData = regions[regionId];
    }
    
    if (activeRegionData && activeRegionData.length) {
      for (var i = 0, length = activeRegionData.length; i < length; i++) {
        var tpl = '<li><a href="'
                  + activeRegionData[i].link +'">'
                  + activeRegionData[i].job
                  +'</a></li>';

        $('#top-region-jobs').append(tpl);
      }
    }
  }

  /**
   * Show Region Name and Top Jobs in View
   * @return {void}
   */
  function showRegionJobs () {
    var regionId = getRegionId($('#top-jobs__map path.active'));

    addRegionName(regionId);
    showTopJobs(regionId);
  }

  /**
   * Show Career salary and requrements by regions
   * @param  {string} id Id of selected region
   * @return {void}
   */
  function showCareerRequired (id) {
    if (careers && id) {
      
      var regionId = id.toLowerCase().split(' ').join('-'),
          activeRegionData = careers[regionId];
    }
    
    if (activeRegionData) {

      $('#career-salary').text(activeRegionData.salary);
      $('#career-certificate').text(activeRegionData.certificate);
    }
  }

  /**
   * Show Region name and career info by region
   * @return {void} 
   */
  function showRegionCareerOptions () {
    var regionId = getRegionId($('#career-map path.active'));

    addRegionName(regionId);
    showCareerRequired(regionId);
  }

  //Show video banner homepage
  var videoModal;

  //Show popup video when click button play
  $('.btn-play-video').on('click', function(event) {
    var buttonPlayVideo = $(event.target);
    var videoSource = buttonPlayVideo.attr('data-source');

    $('#videoModal').find('.modal-video__details').prepend(
      '<video preload autoplay class="video-playing video-player">\
        <source src=' + videoSource + ' type="video/mp4">\
      </video>\
      <div class="button-pause" style="display: none;"><i class="icon-pause"></i><div>');
  });

  //Show modal and show button play and pause video
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
    });

    // Close modal when end video
    videoModal.find('video').on('ended', function () {
      $('#videoModal').modal('hide');
    });
  });

  //Remove video when modal hide
  $('#videoModal').on('hide.bs.modal', function (event) {
    videoModal = $(event.target);
    if(videoModal.find('video').length > 0) {
      videoModal.find('video').remove();
    }
  });


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
      url: 'profile/get-more',
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

  /**
   * Related Careers sorting tabs
   */
  function profileDetail() {
    $('#sortInterests').on('click', function() {
      debugger;
      $('#interest-icons').css('display', 'block');
      $('#careers-by-interests').css('display', 'block');
      $('#skill-icons').css('display', 'none');
      $('#careers-by-skills').css('display', 'none');
    });

    $('#sortSkills').on('click', function() {
      debugger;
      $('#interest-icons').css('display', 'none');
      $('#careers-by-interests').css('display', 'none');
      $('#skill-icons').css('display', 'block');
      $('#careers-by-skills').css('display', 'block');
    });
    console.log('profile');
  }

  profileDetail();




});
