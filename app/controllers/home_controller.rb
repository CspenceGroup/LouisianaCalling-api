class HomeController < ApplicationController
  def index

    topJobs = TopJob.all
    @jobs = {}
    @videos = Video.all
    @regions = Region.all

    # Handle render top job
    topJobs.each do |job|
      if @jobs[job.region]
        temp = {}
        temp[:job] = job.job_title
        temp[:link] = "javascript:void(0);"

        @jobs[job.region] << temp
      else
        @jobs[job.region] = []

        temp = {}
        temp[:job] = job.job_title
        temp[:link] = "javascript:void(0);"

        @jobs[job.region] << temp
      end
    end
  end
end
