class ProfileController < ApplicationController
  def index
    @count = Profile.count
    @profiles = Profile.first(5)
  end

  def getMore

    id = params[:id]
    if id

      # get all records with id less than 'our last id'
      # and limit the results to 3
      profiles = Profile.where('id > ?', id).limit(3).order(:id)

      isSeeMore = false
      profilesCount = Profile.where('id > ?', id).count

      if profilesCount > 3
        isSeeMore = true
      end

      render :json => {
        :profiles => render_to_string('profile/partial/_profile', :layout => false, :locals => { profiles: profiles}),
        :isSeeMore => isSeeMore
      }

      # render :partial => "profile/partial/profile", :locals => { profiles: profiles}
    end
  end
end
