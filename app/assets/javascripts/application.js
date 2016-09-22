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
  var careers = {};
  if ($('#careerMapData').html()) {
    careers = JSON.parse($('#careerMapData').html());
  }

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
   * Replace space in string with %20
   * @param  {string} value
   * @return {string}
   */
  function convertToUrl (value) {
    return value.split(' ').join('%20');
  }

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

      var activeRegionData = careers[id];
    }

    if (activeRegionData) {
      $('#career-salary').html('<i class="icon i-options i-salary"></i><span class="career-options__text">$' + numberWithCommas(activeRegionData.salary_min) + ' - $' + numberWithCommas(activeRegionData.salary_max) +'</span>');
      $('#career-certificate').html('<i class="icon i-options i-certificate"></i><span class="career-options__text">' + activeRegionData.education +'</span>');
    }
  }

  // Format number with comma
  function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
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
  $('#sortInterests').on('click', function() {

    // Active Careers sorted by interests
    $('#interest-icons').css('display', 'block');
    $('#careers-by-interests').css('display', 'block');

    // Hide Careers sorted by skills
    $('#skill-icons').css('display', 'none');
    $('#careers-by-skills').css('display', 'none');

    // Active button
    $('#sortSkills').removeClass('btn-sort-active');
    $('#sortInterests').addClass('btn-sort-active');
  });

  $('#sortSkills').on('click', function() {

    // // Hide Careers sorted by interests
    $('#interest-icons').css('display', 'none');
    $('#careers-by-interests').css('display', 'none');

    // Active Careers sorted by skills
    $('#skill-icons').css('display', 'block');
    $('#careers-by-skills').css('display', 'block');

    // Active button
    $('#sortInterests').removeClass('btn-sort-active');
    $('#sortSkills').addClass('btn-sort-active');
  });

  /**
    * Careers view by tab
  */
  $('#list-view-icon').on('click', function() {

    // Active list view
    $('#list-view').css('display', 'block');
    $('#grid-view').css('display', 'none');
  });

  $('#grid-view-icon').on('click', function() {

    // Active grid view
    $('#list-view').css('display', 'none');
    $('#grid-view').css('display', 'block');
  });


  $("#slider-range").slider({
    range: true,
    min: 0,
    max: 90000,
    values: [0, 90000],
    slide: function( event, ui ) {
      $( "#salary" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
    }
  });

  $( "#salary" ).val( "$" + $( "#slider-range" ).slider( "values", 0 ) +
      " - $" + $( "#slider-range" ).slider( "values", 1 ) );

  /**
   *
   * Handle for Homepage Searchbar
   *
   */
  $('#searchHomepage').submit(function(e) {
    e.preventDefault();

    var target = e.target,
        careerName = convertToUrl(target[0].value),
        region = convertToUrl(target[1].value),
        type = target[2].value,
        url = '?title=' + careerName;

    if (region) {

      url = url + '&region=' + region;
    }

    if (type && type === 'careers') {

      // Redirect to careers landing page
      var urlCareers = '/careers' + url;
      window.location = urlCareers;
    } else if (type && type === 'programs') {

      // Redirect to programs landing page
    }
  });

  // autocomplete for career page.
  var availableCareers = {};
  if ($('#availableCareers').html()) {
    availableCareers = JSON.parse($('#availableCareers').html());
  }

  $("#careerAutocomplete").autocomplete({
    source: availableCareers
  });


  /*
    Get value checkbox when checked
  */
  $('.square-checkbox').click(function() {
    getValueCheck();
  });

  $("#slider-range").on("slidechange", function() {
    getValueCheck();
  });

  getValueCheck();


  //
  function getValueCheck() {
    var salary_min = $("#slider-range").slider("values")[0],
       salary_max = $("#slider-range").slider("values")[1];

    var data = {
      regions: [],
      industrys: [],
      skills: [],
      interests: [],
      educations: [],
      hot_jobs: [],
      salary_max: [],
      salary_min: []
    }

    $('.square-checkbox:checked').each(function() {
      data[$(this).attr('name')].push($(this).val());
    });

    data.salary_max.push(salary_max);
    data.salary_min.push(salary_min);

    if(!data.regions.length) {
      delete data.regions;
    } else {
      data.regions = data.regions.join(',')
    }

    if(!data.industrys.length) {
      delete data.industrys;
    } else {
      data.regions = data.industrys.join(',')
    }

    if(!data.skills.length) {
      delete data.skills;
    } else {
      data.regions = data.skills.join(',')
    }

    if(!data.interests.length) {
      delete data.interests;
    } else {
      data.regions = data.interests.join(',')
    }

    if(!data.educations.length) {
      delete data.educations;
    } else {
      data.regions = data.educations.join(',')
    }

    if(!data.hot_jobs.length) {
      delete data.hot_jobs;
    } else {
      data.regions = data.hot_jobs.join(',')
    }

    console.log(data);

    $.ajax({
      url : '/career/filter&'
      type : "get",
      dateType:"text",
      traditional: true,
      data : data
    });
  }

  //Click button see more
  $('#careers-see-more').click(function() {
    var last_id = parseInt($('.careers-grid-details__item').last().attr('id'));
    getValueCheck(last_id);
  });


  //Show button see more when careers have value
  var btn_see_more = $('.careers-grid-details__item').length;
  if(btn_see_more > 6) {
    $('#careers-see-more').show();
  }

  // autocomplete for career page.
  var availableCareers = {};
  if ($('#availableCareers').html()) {
    availableCareers = JSON.parse($('#availableCareers').html());
  }

  $("#careerAutocomplete").autocomplete({
    source: availableCareers
  });
});
