
$(document).ready ->
  # js file for profile page
  # function seeMore
  $('#profileSeeMore').click ->
    # hide load more link
    _seeMore = $(this)
    _loading = $('#loading-gif')
    _seeMore.hide()
    # show loading gif
    _loading.show()
    last_id = $('.more-stories__details').last().attr('data-id')
    # make an ajax call passing along our last user id
    $.ajax
      type: 'GET'
      url: 'profile/get-more'
      data: id: last_id
      success: (response) ->
        # hide the loading gif
        _loading.hide()
        $('#moreStories').append response
        _id = $('.more-stories__details').last().attr('data-id')
        if _id - last_id == 3
          _seeMore.show()
        return
      error: (response) ->
        console.log response
        return
    return
  return

# ---
