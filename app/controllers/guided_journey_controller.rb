class GuidedJourneyController < ApplicationController
  before_filter :datas_for_binding, only: [:index]

  def index
  end

  private

  def datas_for_binding
    @regions = Region.all
    @educations = Education.all
    @skills = Skill.all
    @interests = Interest.all
  end
end
