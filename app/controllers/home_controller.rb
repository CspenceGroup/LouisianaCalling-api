class HomeController < ApplicationController
  def index
    @videos = Video.all
    @regions = Region.all.alphabetical
    @careers_slider = Career.first(5)
  end
end
