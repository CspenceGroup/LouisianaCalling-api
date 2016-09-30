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

  /****************************************
   *             HOMEPAGE                 *
   ****************************************/

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

  // set home page carousel move
  $('#carousel-banner, #carousel-great-jobs').carousel({
      interval: 5000
    });

  //Remove video when modal hide
  $('#videoModal').on('hide.bs.modal', function (event) {
    videoModal = $(event.target);
    if(videoModal.find('video').length > 0) {
      videoModal.find('video').remove();
    }
  });

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
        url = '?title=' + careerName,
        toUrl;

    if (region) {

      url = url + '&region=' + region;
    }

    if (type && type === 'careers') {

      // Redirect to careers landing page
      toUrl = '/careers' + url;
      window.location = toUrl;
    } else if (type && type === 'programs') {

      toUrl = '/programs' + url;
      window.location = toUrl;
    }
  });

  /**
   * Scrolling fixed header with locked screen 1200px
   */
  $(window).on('wheel scroll', function() {
    if($(window).scrollLeft() > 60) {

      $('.site-header').css("left","-" + ($(window).scrollLeft() + 60) +"px");
    } else {

      $('.site-header').css("left","-" + $(window).scrollLeft() + "px");
    }

  })

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


  /****************************************
   *            CAREER DETAILS            *
   ****************************************/

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
   * Search nearby programs from career details page
   */
  $('#search-career-detail').submit(function(e) {
    e.preventDefault();

    var target = e.target,
        careerName = convertToUrl(target[0].value),
        region = convertToUrl(target[1].value),
        url = '/programs?title=' + careerName;

    if (region) {

      url = url + '&region=' + region;
      window.location = url;
    } else {
      window.location = url;
    }
  });

  // autocomplete for program in careers details page
  var availableProgramCareer = {};
  if ($('#availableProgramCareer').html()) {
    availableProgramCareer = JSON.parse($('#availableProgramCareer').html());
  }

  $("#programAutocompleteCareers").autocomplete({
    source: availableProgramCareer
  });

  /****************************************
   *            CAREER LANDING            *
   ****************************************/

  /**
    * Careers view by tab
  */
  $('#list-view-icon').on('click', function() {

    // Active list view
    $('#list-view').css('display', 'block');
    $('.careers-view-by__list').addClass('active-tab');
    $('.careers-view-by__grid').removeClass('active-tab');
    $('#grid-view').css('display', 'none');
  });

  $('#grid-view-icon').on('click', function() {

    // Active grid view
    $('#list-view').css('display', 'none');
    $('#grid-view').css('display', 'block');
    $('.careers-view-by__grid').addClass('active-tab');
    $('.careers-view-by__list').removeClass('active-tab');
  });

  $("#slider-range").slider({
    range: true,
    min: 15000,
    max: 187000,
    values: [30000, 80000],
    slide: function( event, ui ) {
      $("#salary").val("$" + ui.values[0].toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " - $" + ui.values[1].toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
    }
  });

  $("#salary").val( "$" + $("#slider-range").slider("values", 0).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " - $" + $("#slider-range").slider("values", 1).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));

  /*
    Get value checkbox when checked
  */
  $('.square-checkbox').click(function() {

    if($(this).closest('.careers-filter').length) {
      $('.careers-grid-details').hide();
      $('.see-more-careers').hide();
      getValueCheck(0);
    }

    if($(this).closest('.program-filter').length) {
      $('#program-container-list, #program-container-map').hide();
      $('#education-see-more-map, #education-see-more').hide();

      filterProgram(0);
    }

  });

  // Filter careers by salary range
  $("#slider-range").on("slidechange", function() {
    $('.careers-grid-details').hide();
    $('.see-more-careers').hide();
    getValueCheck(0);
  });

  // Filter program by tuition cost
  $("#tuition-cost").on("slidechange", function() {
    $('#program-container-list, #program-container-map').hide();
    $('#education-see-more-map, #education-see-more').hide();
    filterProgram(0);
  });

  //Requets url when filter follow condition careers
  var timeout;
  function getValueCheck(id) {
    if(id > 0) {
      $('.indicator-loading-see-more').show();
      $('.see-more-careers').hide();
    } else {
      $('.indicator-loading').show();
    }
    clearTimeout(timeout);
    timeout = setTimeout(function() {
      var salary_min = $("#slider-range").slider("values")[0],
        salary_max = $("#slider-range").slider("values")[1],
        data = {
          regions: [],
          industrys: [],
          skills: [],
          interests: [],
          educations: [],
          demands: [],
          salary_max: [],
          salary_min: [],
          last_id: [],
          title: ""
        }

      $('.square-checkbox:checked').each(function() {
        data[$(this).attr('name')].push($(this).val());
      });

      data.salary_max.push(salary_max);
      data.salary_min.push(salary_min);
      data.last_id.push(id);
      data.title = $('#careerAutocomplete').val();

      if(!data.regions.length) {
        delete data.regions;
      } else {
        data.regions = data.regions.join(',')
      }

      if(!data.industrys.length) {
        delete data.industrys;
      } else {
        data.industrys = data.industrys.join(',')
      }

      if(!data.skills.length) {
        delete data.skills;
      } else {
        data.skills = data.skills.join(',')
      }

      if(!data.interests.length) {
        delete data.interests;
      } else {
        data.interests = data.interests.join(',')
      }

      if(!data.educations.length) {
        delete data.educations;
      } else {
        data.educations = data.educations.join(',')
      }

      if(!data.demands.length) {
        delete data.demands;
      } else {
        data.demands = data.demands.join(',')
      }

      if(data.title == "") {
        delete data.title;
      }

      $.ajax({
        url : '/career/filter',
        type : "get",
        dateType:"text",
        traditional: true,
        data : data,
        success: function(response) {
          if (id > 0) {
            $('.indicator-loading-see-more').hide();
            $('#careersGrid').append(response.careers);
            $('#careersList').append(response.list);
          } else {
            $('.indicator-loading').hide();
            $('.careers-grid-details').show();
            $('#careersGrid').html(response.careers);
            $('#careersList').html(response.list);
          }

          if (response.isSeeMore) {
            $('#careers-see-more,#careers-see-more-list').show();
          } else {
            $('#careers-see-more,#careers-see-more-list').hide();;
          }
        },
        error: function() {
          $('.indicator-loading-see-more').hide();
          $('.indicator-loading').hide();
        }

      });
    }, 500);

  }

  // Click button Search
  $('#careerSearch').click(function () {
    var searchTitle = $('#careerAutocomplete').val();
    $('.careers-grid-details').hide();
    $('#careers-see-more,#careers-see-more-list').hide();

    if (searchTitle && searchTitle != "") {
      getValueCheck(0);
    }
  });

  //Click button see more
  $('#careers-see-more, #careers-see-more-list').click(function() {
    var last_id = parseInt($('.careers-grid-details__item').last().attr('id'));
    getValueCheck(last_id);
  });

  // autocomplete for career page.
  var availableCareers = {};
  if ($('#availableCareers').html()) {
    availableCareers = JSON.parse($('#availableCareers').html());
  }

  $("#careerAutocomplete").autocomplete({
    source: availableCareers
  });

  /****************************************
   *             PROGRAM LANDING                 *
   ****************************************/

  /*Show and hide filter*/
  $('.program-filter-show').click(function() {
    $(this).hide();
    $('.program-filter-hide').show();
  });

  $('.program-filter-hide').click(function() {
    $(this).hide();
    $('.program-filter-show').show();
  });

  /*Show program by list view or map view*/
  $('.program-view-by__list').click(function() {
    $('#program-list-view').show();
    $('#program-map-view').hide();
    $('.program-view-by__list').addClass('active-tab');
    $('.program-view-by__map').removeClass('active-tab');
  });

  $('.program-view-by__map').click(function() {
    $('#program-list-view').hide();
    $('#program-map-view').show();
    $('.program-view-by__list').removeClass('active-tab');
    $('.program-view-by__map').addClass('active-tab');

    $(document).trigger('initGoogleMap');

  });

  //Click button see more
  $('#education-see-more-map, #education-see-more').click(function() {
    var last_id = parseInt($('.edu-program-info--item').last().attr('id'));
    filterProgram(last_id);
  });

  // Tuition cost
  $("#tuition-cost").slider({
    range: true,
    min: 0,
    max: 40000,
    values: [10000, 20000],
    slide: function( event, ui ) {
      $("#tuition").val("$" + ui.values[0].toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " - $" + ui.values[1].toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
    }
  });

  $("#tuition").val( "$" + $("#tuition-cost").slider("values", 0).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + " - $" + $("#tuition-cost").slider("values", 1).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));

  // Filter programs
  function filterProgram(id) {
    if(id > 0) {
      $('.indicator-loading-see-more').show();
      $('#education-see-more-map, #education-see-more').hide();
    } else {
      $('.indicator-loading').show();
    }
    clearTimeout(timeout);
    timeout = setTimeout(function() {
      var cost_min = $("#tuition-cost").slider("values")[0],
          cost_max = $("#tuition-cost").slider("values")[1],
          data = {
            industries: [],
            cost_max: [],
            cost_min: [],
            financials: [],
            programs: [],
            hours: [],
            times: [],
            educations: [],
            last_id: [],
            title: "",
            regions: []
          };

      $('.square-checkbox:checked').each(function() {
        data[$(this).attr('name')].push($(this).val());
      });

      data.cost_max.push(cost_max);
      data.cost_min.push(cost_min);
      data.last_id.push(id);
      data.title = $('.program-search-input').val();
      // data.regions.push($("#programRegion").val())

      if(!data.industries.length) {
        delete data.industries;
      } else {
        data.industries = data.industries.join(',')
      }

      if(!data.financials.length) {
        delete data.financials;
      } else {
        data.financials = data.financials.join(',')
      }

      if(!data.programs.length) {
        delete data.programs;
      } else {
        data.programs = data.programs.join(',')
      }

      if(!data.hours.length) {
        delete data.hours;
      } else {
        data.hours = data.hours.join(',')
      }

      if(!data.times.length) {
        delete data.times;
      } else {
        data.times = data.times.join(',')
      }

      if(!data.educations.length) {
        delete data.educations;
      } else {
        data.educations = data.educations.join(',')
      }

      if(data.title == "") {
        delete data.title;
      }

      if(!data.regions.length) {
        delete data.regions
      } else {
        data.regions = data.regions.join(',')
      }

      $.ajax({
        url : '/education/filter',
        type : "get",
        dateType:"text",
        traditional: true,
        data : data,
        success: function(response) {
          if (id > 0) {
            $('.indicator-loading-see-more').hide();
            $('#program-container-map').append(response.map);
            $('#program-container-list').append(response.list);
            updateProgramsMapData(response.programs);
            addMarkerToMap(response.programs);
          } else {
            // remove all of map markers
            programMapMarkers = [];
            // set map data
            programsMapData = response.programs;
            // reinit map
            initMap();
            $('.indicator-loading').hide();
            $('#program-container-list, #program-container-map').show();
            $('#program-container-map').html(response.map);
            $('#program-container-list').html(response.list);
          }

          if (response.isSeeMore) {
            $('#education-see-more-map, #education-see-more').show();
          } else {
            $('#education-see-more-map, #education-see-more').hide();
          }
        },
        error: function() {
          $('.indicator-loading-see-more').hide();
          $('.indicator-loading').hide();
        }
      });
    }, 500);
  }

  // Click button Search program
  $('#programSearch').click(function (e) {
    e.preventDefault();
    var searchProgram = $('#programInput').val();
    $('#education-see-more-map, #education-see-more').hide();
    $('#program-container-list, #program-container-map').hide();

    // if (searchProgram && searchProgram != "") {
      filterProgram(0);
    // }
  });

  // autocomplete for program page.
  var availableProgram = {};
  if ($('#availableProgram').html()) {
    availableProgram = JSON.parse($('#availableProgram').html());
  }

  $("#programAutocomplete").autocomplete({
    source: availableProgram
  });

  /*
    Map
  */
  // Create map in program landing
  var programsMap = null;
  var programMapMarkers = [];

  var programsMapData = {};
  if ($('#program-map-data').html()) {
    programsMapData = JSON.parse($('#program-map-data').html());
  }

  // refresh google map when trigger
  $(document).on("refreshGoogleMap", function(){
    if (programsMap){
      google.maps.event.trigger(map, 'resize');
    }
  });

  //Init google map
  $(document).on("initGoogleMap", function(){
    initMap();
  });


  // Add marker for map
  var initMap = function() {
    // Create a map object and specify the DOM element for display.

    var lat = 31.391830,
      lng = -92.329102,
      length = programsMapData.length;

    if (length > 0) {
      lat = parseInt(programsMapData[0].lat);
      lng = parseInt(programsMapData[0].lng);
    }

    programsMap = new google.maps.Map(document.getElementById('program-map'), {
      center: {lat: lat, lng: lng},
      zoom: 7
    });

    addMarkerToMap(programsMapData);
  }

  var updateProgramsMapData = function(programs) {
    programsMapData = programsMapData.concat(programs);
  }

  var addMarkerToMap = function(programs) {
    if(programsMap) {
      for (var i = 0; i < programs.length; i++) {
        var marker = new MarkerWithLabel({
         position: new google.maps.LatLng(programs[i].lat, programs[i].lng),
         icon: 'assets/marker.png',
         map: programsMap,
         title: programs[i].title,
         labelContent: String(programs[i].id),
         labelAnchor: new google.maps.Point(20, 36),
         labelClass: "labels-marker"
        });

        programMapMarkers.push(marker);
      }

      fixMapZoomToSeeAllMarker();
    }
  }

  var fixMapZoomToSeeAllMarker = function() {
    if(programsMap && programMapMarkers.length > 0) {
      var bounds = new google.maps.LatLngBounds();
      for (var i = 0; i < programMapMarkers.length; i++) {
       bounds.extend(programMapMarkers[i].getPosition());
      }

      programsMap.setCenter(bounds.getCenter());
      programsMap.fitBounds(bounds);
    }
  }

});
