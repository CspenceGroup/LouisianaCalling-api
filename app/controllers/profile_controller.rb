class ProfileController < ApplicationController
  def index
    @count = Profile.count
    @profiles = Profile.first(5)
  end

  def getMore
    id = params[:id]

    return unless id.present?
    # get all records with id less than 'our last id'
    # and limit the results to 3
    profiles = Profile.where('id > ?', id)

    is_see_more = profiles.count > 3 ? true : false
    profiles = profiles.limit(3).order(:id)

    render json: {
      profiles: render_to_string(
        'profile/partial/_profile', layout: false, locals: { profiles: profiles }
      ),
      is_see_more: is_see_more
    }
  end

  def detail
    @profile = Profile.friendly.find(params[:slug])
  end
end
