class HomeController < ApplicationController
  def index
    @jobs = {}
    @videos = Video.all
    @regions = Region.all
    @careers_slider = Career.first(5)

    TopJob.all.valid.group_by(&:region).each do |region, top_jobs|
      @jobs[region.name] = top_jobs.map do |top_job|
        {
          job: top_job.career.title,
          link: career_detail_path(top_job.career)
        }
      end
    end
  end
end
