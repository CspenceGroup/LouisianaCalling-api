'use strict';
$(document).on('turbolinks:load', function(){


  /****************************************
   *             HOMEPAGE                 *
   ****************************************/

  /**
  * Handle Data
  */

  var regions = {};
  if ($('#mapData').data('map')) {
    regions = $('#mapData').data('map');
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
   * Start video
   */
  startCarouselVideo();
  function startCarouselVideo() {
    var videos = $('video');
    if (videos && videos[0]) {
      videos[0].play();
    }
  }
  /**
   * This function handle the action when user click on region map
   * @return void
   */
  $('.top-jobs__map path').hover(function (e) {
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

      var activeRegionData = careers[id];
    }

    if (activeRegionData) {
      var educations = activeRegionData.educations.map(function(edu) { return edu.name; })
      $('#career-salary').html('<i class="icon i-options i-salary"></i><span class="career-options__text">$' + numberWithCommas(activeRegionData.salary_min) + ' - $' + numberWithCommas(activeRegionData.salary_max) +'</span>');
      $('#career-certificate').html('<i class="icon i-options i-certificate"></i><span class="career-options__text" title="'+ educations.join(', ') + '">' + educations.join(', ') +'</span>');

      var flame_icons = [];

      for (var i = activeRegionData.demand; i > 0; i--) {
        flame_icons.push('<i class="icon i-flame"></i>')
      }
      $('#career-flames').html(flame_icons.join(''));
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
    $('.career-options__text').dotdotdot({});
  }

  //Show video banner homepage
  var videoModal;

  //Show popup video when click button play
  $('.btn-play-video').on('click', function(event) {
    var buttonPlayVideo = $(event.target),
        playVideoId = buttonPlayVideo.attr('data-source');

    if (playVideoId) {
      var videoModelElement = $('#' + playVideoId);

      $('#videoModal').find('.modal-video__details').hide();

      videoModelElement.show();
      videoModelElement.find('video')[0].play();
    }
  });

  $('#videoModal').find('video').on('click', function(e) {
      var buttonPause = $(this).next();

      e.preventDefault();
      if(this.paused) {
        this.play();
        buttonPause.hide();
      } else {
        this.pause();
        buttonPause.show();
      }
    }).on('ended', function () {
      // Close modal when end video
      $('#videoModal').modal('hide');
    });

  // //Show modal and show button play and pause video
  $('#videoModal').on('hide.bs.modal', function (event) {
    $(this).find('video').each(function(i, el) {
      el.pause();
    });
  }).on('show.bs.modal', function (event) {
    $(this).find('.button-pause').hide();
  });

  //close pop up when they click anywhere that have no text or video
  $('.modal-video__details').on('click', function(event) {
    console.log(event.target);
    if(event.target === this || event.target.className === 'modal-video__close') {
      $('#videoModal').modal('hide');
      $(this).find('video')[0].pause();
    }
  });

  $('.modal-video__desc').on('click', function(event) {
    if(event.target === this) {
      $('#videoModal').modal('hide');
    }
  })

  // set home page carousel move
  $('#carousel-great-jobs').carousel({
    interval: 5000
  });

  $('#carousel-banner').carousel({
    interval: false
  });

  $('#carousel-banner').on('slid.bs.carousel', function (evt) {

    // stop all current videos
    var videos = $(this).find('video');
    if (videos) {
      for (var i = 0; i < videos.length; i ++) {
        videos[i].pause();
      }
    }

    // play active video
    var video = $(this).find('.carousel-item.active').find('video')[0].play();
  });

  $('#carousel-banner').find('video').on('ended', function () {
    $('#carousel-banner').carousel('next');
  });

  //Remove video when modal hide
  // $('#videoModal').on('hide.bs.modal', function (event) {
  //   videoModal = $(event.target);
  //   if(videoModal.find('.video-container').length > 0) {
  //     videoModal.find('.video-container').remove();
  //   }
  // });

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
        url = "",
        toUrl;

    // if (careerName && region) {

    //   url = url + '?title=' + careerName + '&region=' + region;
    // }
    if(!careerName) {
      $('.alert-danger-search--career').show();
      $('.alert-danger-search--region').hide();
    } else if(!region) {
      $('.alert-danger-search--career').hide();
      $('.alert-danger-search--region').show();
    } else {
      url = url + '?title=' + careerName + '&region=' + region;
    }

    if (url != "") {
      if (type && type === 'careers') {

        // Redirect to careers landing page
        toUrl = '/careers' + url;
        window.location = toUrl;
      } else if (type && type === 'programs') {

        toUrl = '/educations' + url;
        window.location = toUrl;
      }
    }

    return false;
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

  });
});
