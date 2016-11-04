class HomeController < ApplicationController
  def index
    @videos = Video.all
    @regions = Region.all.alphabetical
    @careers_slider = Career.order(:numerical_order).offset(0).limit(5)

    @careers_and_programs = Program.all.select(:title).map(&:title).uniq
    @careers_and_programs.push(Career.all.select(:title).map(&:title).uniq)

    @careers_and_programs = @careers_and_programs.flatten
  end
end
