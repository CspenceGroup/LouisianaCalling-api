class ProfileController < ApplicationController
  def index
    count = Profile.count
    @profiles = {}
    if count > 5
      @profiles = Profile.first(5)
    end

  end

  def getMore

    id = params[:id]
    if id
      # get all records with id less than 'our last id'
      # and limit the results to 5
      profiles = Profile.where('id > ?', id).limit(3).order(:id)

      render :partial => "profile/partial/profile", :locals => { profiles: profiles}
    end
  end
end
