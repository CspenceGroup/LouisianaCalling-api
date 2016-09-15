'use strict';

$(document).ready(function(){

  /**
  * Handle Data
  */
  var regions = {
    "alexandria": [
      {
        "job": "Registered Nurse",
        "link": "javascript:void(0);"
      },
      {
        "job": "Chemical Technician",
        "link": "javascript:void(0);"
      },
      {
        "job": "Radiation Therapist",
        "link": "javascript:void(0);"
      },
      {
        "job": "Commercial Drivers",
        "link": "javascript:void(0);"
      },
      {
        "job": "Cargo and Freight Agents",
        "link": "javascript:void(0);"
      },
      {
        "job": "Registered Nurse",
        "link": "javascript:void(0);"
      },
      {
        "job": "Chemical Technician",
        "link": "javascript:void(0);"
      },
      {
        "job": "Radiation Therapist",
        "link": "javascript:void(0);"
      },
      {
        "job": "Commercial Drivers",
        "link": "javascript:void(0);"
      },
      {
        "job": "Commercial Drivers",
        "link": "javascript:void(0);"
      }
    ],
    "lake-charles": [
      {
        "job": "Registered Nurse",
        "link": "javascript:void(0);"
      },
      {
        "job": "Chemical Technician",
        "link": "javascript:void(0);"
      },
      {
        "job": "Radiation Therapist",
        "link": "javascript:void(0);"
      }
    ],
    "lafayette": [
      {
        "job": "Registered Nurse",
        "link": "javascript:void(0);"
      },
      {
        "job": "Chemical Technician",
        "link": "javascript:void(0);"
      },
      {
        "job": "Radiation Therapist",
        "link": "javascript:void(0);"
      },
      {
        "job": "Registered Nurse",
        "link": "javascript:void(0);"
      }
    ]
  };

  /**
   * Init Map and Region Top Jobs
   */
  showRegionJobs();

  /**
   * This function handle the action when user click on region map
   * @return void
   */
  $('path').click(function (e) {

    // Reset top job list
    $('#top-region-jobs').empty();

    /**
     * Active clicked region & show top jobs in view
     */
    
    $('.top-jobs__map path').removeClass('active');

    if ($(this).hasClass('lafayette')) {

      $('.lafayette').addClass('active');
      showRegionJobs();
    } else {

      $(this).addClass('active');
      showRegionJobs();
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
    return name.split('-').join(' ');
  }

  /**
   * Get Region Name from Element
   * @param  {object} ele element for getting its Id
   * @return {string}     region name after converting
   */
  function getRegionId (ele) {
    return ele[0].id;
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
    var activeRegionData = regions[regionId];

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
    var regionId = getRegionId($('.top-jobs__map path.active'));

    addRegionName(regionId);
    showTopJobs(regionId);
  }

});
