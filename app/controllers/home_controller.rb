class HomeController < ApplicationController
  def index
    top_jobs = TopJob.all
    @jobs = {}
    @videos = Video.all
    @regions = Region.all

    # Handle render top job
    top_jobs.each do |job|
      @jobs[job.region] = [] unless @jobs[job.region].present?

      temp = {
        job: job.job_title,
        link: 'javascript:void(0);'
      }

      @jobs[job.region] << temp
    end
  end
end
