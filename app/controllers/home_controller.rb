class HomeController < ApplicationController
  def index
    @jobs = {}
    @videos = Video.all
    @regions = Region.all

    TopJob.all.valid.group_by(&:region).each do |region, top_jobs|
      @jobs[region.name] = top_jobs.map do |top_job|
        {
          job: top_job.career.title,
          link: 'javascript:void(0);'
        }
      end
    end
  end
end
