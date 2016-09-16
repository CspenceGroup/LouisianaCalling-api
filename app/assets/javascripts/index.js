// 'use strict';

// $(document).ready(function(){

//   /**
//   * Handle Data
//   */
//   var regions = JSON.parse($('#mapData').html());

//   /**
//    * Init Map and Region Top Jobs
//    */
//   showRegionJobs();

//   /**
//    * This function handle the action when user click on region map
//    * @return void
//    */
//   $('path').click(function (e) {

//     // Reset top job list
//     $('#top-region-jobs').empty();

//     /**
//      * Active clicked region & show top jobs in view
//      */

//     $('.top-jobs__map path').removeClass('active');

//     if ($(this).hasClass('lafayette')) {

//       $('.lafayette').addClass('active');
//       showRegionJobs();
//     } else {

//       $(this).addClass('active');
//       showRegionJobs();
//     }
//   });

//   /**
//    * COMMON FUNCTIONS
//    */

//   /**
//    * Convert ID get from map path into Region Name
//    * @param  {string} name ID of map's path
//    * @return {string} Region Name after convert
//    */
//   function convertToRegionName (name) {
//     return name.split('-').join(' ');
//   }

//   /**
//    * Get Region Name from Element
//    * @param  {object} ele element for getting its Id
//    * @return {string}     region name after converting
//    */
//   function getRegionId (ele) {
//     return ele[0].id;
//   }

//   /**
//    * Add Region Name to Map Heading
//    * @param {string} name Name of the selected region
//    */
//   function addRegionName (regionId) {
//     var region = convertToRegionName(regionId);

//     $('#region-name').text(region);
//   }

//   /**
//    * Show Top Jobs of selected region in View
//    * @param  {string} regionId Id of selected region
//    * @return {void}
//    */
//   function showTopJobs (regionId) {
//     var activeRegionData = regions[regionId];

//     if (activeRegionData && activeRegionData.length) {
//       for (var i = 0, length = activeRegionData.length; i < length; i++) {
//         var tpl = '<li><a href="'
//                   + activeRegionData[i].link +'">'
//                   + activeRegionData[i].job
//                   +'</a></li>';

//         $('#top-region-jobs').append(tpl);
//       }
//     }
//   }

//   /**
//    * Show Region Name and Top Jobs in View
//    * @return {void}
//    */
//   function showRegionJobs () {
//     var regionId = getRegionId($('.top-jobs__map path.active'));

//     addRegionName(regionId);
//     showTopJobs(regionId);
//   }

//   //Show video banner homepage
//   var videoModal;

//   //Show popup video when click button play
//   $('.btn-play-video').on('click', function(event) {
//     var buttonPlayVideo = $(event.target);
//     var videoSource = buttonPlayVideo.attr('data-source');

//     $('#videoModal').find('.modal-video__details').prepend(
//       '<video preload autoplay class="video-playing video-player">\
//         <source src=' + videoSource + ' type="video/mp4">\
//       </video>\
//       <div class="button-pause" style="display: none;"><i class="icon-pause"></i><div>');
//   });

//   //Show modal and show button play and pause video
//   $('#videoModal').on('shown.bs.modal', function (event) {
//     videoModal = $(event.target);
//     var buttonPause = videoModal.find('.button-pause');

//     videoModal.find('video').on('click', function(e) {
//       e.preventDefault();
//       if(this.paused) {
//         this.play();
//         buttonPause.hide();
//       } else {
//         this.pause();
//         buttonPause.show();
//       }
//     })
//   });

//   //Remove video when modal hide
//   $('#videoModal').on('hide.bs.modal', function (event) {
//     videoModal = $(event.target);
//     if(videoModal.find('video').length > 0) {
//       videoModal.find('video').remove();
//     }
//   });

// });
