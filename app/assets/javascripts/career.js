'use strict';

$(document).on('turbolinks:load', function(){


  /****************************************
   *            CAREER DETAILS            *
   ****************************************/

  /**
   * Related Careers sorting tabs
   */
  $('#sortInterests').on('click', function() {
    $(this)
      .closest('.related-careers-container')
      .removeClass('career-skill-active')
      .addClass('career-interest-active');
    $(".related-item__name").dotdotdot({});
  });

  $('#sortSkills').on('click', function() {
    $(this)
      .closest('.related-careers-container')
      .removeClass('career-interest-active')
      .addClass('career-skill-active');
    $(".related-item__name").dotdotdot({});
  });

  /**
   * Search nearby programs from career details page
   */
  $('#search-career-detail').submit(function(e) {
    e.preventDefault();

    var target = e.target,
        careerName = convertToUrl(target[0].value),
        region = convertToUrl(target[1].value),
        url;

    if (careerName != '' || !careerName) {
      if (careerName && region) {

        url = '/educations?title=' + careerName + '&region=' + region;
        window.location = url;
      } else {

        return false;
      }
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

  // Truncate name careers for map in career landing
  $(".career-title--pull-left").dotdotdot({});

  /****************************************
   *            CAREER LANDING            *
   ****************************************/

  /**
    * Careers view by tab
  */
  $('#list-view-icon').on('click', function() {

    $(this)
      .closest('.careers-result__container')
      .removeClass('career-grid-view-active')
      .addClass('career-list-view-active');
  });

  $('#grid-view-icon').on('click', function() {

    $(this)
      .closest('.careers-result__container')
      .removeClass('career-list-view-active')
      .addClass('career-grid-view-active');
  });

  $("#slider-range").slider({
    range: true,
    min: 15000,
    max: 187000,
    values: [15000, 80000],
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
          industries: [],
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

      if(!data.industries.length) {
        delete data.industries;
      } else {
        data.industries = data.industries.join(',')
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

          lazyloadImages();

          $(".related-item__name").dotdotdot({});

          if (response.is_see_more) {
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

    getValueCheck(0);
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
  $('#programListView').click(function() {
    $(this)
      .closest('.program-list')
      .removeClass('program-map-active')
      .addClass('program-list-active');
  });

  $('#programMapView').click(function() {
    $(this)
      .closest('.program-list')
      .removeClass('program-list-active')
      .addClass('program-map-active');

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
    values: [0, 4000],
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
        url : '/educations/filter',
        type : "get",
        dateType:"text",
        traditional: true,
        data : data,
        success: function(response) {
          if (id > 0) {
            $('.indicator-loading-see-more').hide();
            $('#program-container-map').append(response.map);
            $('#program-container-list').append(response.list);
            updateProgramsMapData(response.programs, response.ids);
          } else {
            // remove all of map markers
            programMapMarkers = [];
            // set map data
            programsMapData = response.programs;
            programsMapIds = response.ids;
            // reinit map
            initMap();
            $('.indicator-loading').hide();
            $('#program-container-map').show().html(response.map);
            $('#program-container-list').show().html(response.list);
          }

          lazyloadImages();

          if (response.is_see_more) {
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
  var programsMapIds = [];

  var programsMapData = {};
  if ($('#program-map-data').html()) {
    programsMapData = JSON.parse($('#program-map-data').html());
    programsMapIds = JSON.parse($('#program-map-ids-data').html());
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

    addMarkerToMap(programsMapData, programsMapIds);
  }

  var updateProgramsMapData = function(programs, ids) {
    programsMapData = programsMapData.concat(programs);
    programsMapIds = programsMapIds.concat(programs, ids);
    addMarkerToMap(programsMapData, programsMapIds);
  }

  var addMarkerToMap = function(programs, ids) {
    if(programsMap) {
      for (var i = 0; i < programs.length; i++) {
        var marker = new MarkerWithLabel({
          position: new google.maps.LatLng(programs[i].lat, programs[i].lng),
          icon: 'http://louisiana-calling.s3.amazonaws.com/icons/map-icon.png',
          map: programsMap,
          title: programs[i].title,
          labelContent: String(ids.indexOf(programs[i].id) + 1),
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

  // Apply lazyload
  function lazyloadImages() {
    $("img.lazy-load").lazyload({
      effect : "fadeIn",
      event : "timeout"
    });

    // Trigger timeout event for lazyload
    var timeout = setTimeout(function() {
      $("img.lazy-load").trigger("timeout");
    }, 200);
  }

  lazyloadImages();

  $(".related-item__name").dotdotdot({});
});
