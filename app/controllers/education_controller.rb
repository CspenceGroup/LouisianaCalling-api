class EducationController < ApplicationController
  def index

    tuition_min = 0;
    tuition_max = 4000;
    offset = 3

    @list_of_regions = Region.all
    @list_of_industries = Cluster.all
    @list_of_programs = Program.select(:title).map(&:title).uniq

    if !params["title"] && !params["region"]
      @programs = Program.where("tuition_max <= #{tuition_max} AND tuition_min >= #{tuition_min}").first(offset)
      @isSeeMore = false

      if Program.where("tuition_max <= #{tuition_max} AND tuition_min >= #{tuition_min}").count > offset
        @isSeeMore = true
      end
    else

      @title = params["title"].downcase if params["title"]
      @region = params["region"]

      @programs = Program.where("(LOWER(title) like '%#{@title}%' OR LOWER(institution_name) like '%#{@title}%') AND region like '%#{@region}%' AND tuition_max <= #{tuition_max} AND tuition_min >= #{tuition_min}").first(offset)
      @isSeeMore = false

      if Program.where("(LOWER(title) like '%#{@title}%' OR LOWER(institution_name) like '%#{@title}%') AND region like '%#{@region}%' AND  tuition_max <= #{tuition_max} AND tuition_min >= #{tuition_min}").count > offset
        @isSeeMore = true
      end
    end
  end

  def detail
    @programs = Program.where(:slug => params[:slug])
    @program = @programs.first
    @mapKey = "AIzaSyB37PvABXHFveMjk-4AzolBlsuUqVC-if8"
  end

  def filter
    ## get list of industries
    clusters = Cluster.all
    list_of_clusters = []
    clusters.each do |cluster|
      list_of_clusters[cluster[:id]] = cluster[:name]
    end

    ## get list of region
    regions = Region.all
    list_of_regions = []
    regions.each do |region|
      list_of_regions[region[:id]] = region[:name]
    end

    list_of_financials = ["Scholarship", "Financial Aid/Grant"]

    list_of_program_durations = ["8 Weeks", "3 Months", "6 Months", "1 Year or 2 Semesters", "2 Years or 4 Semesters", "2 Years+"]

    list_of_hours_per_week = ["3 - 10 Hours", "11 - 20 Hours", "21 - 30 Hours", "31 - 40 Hours"]

    list_of_time_of_day = ["Day", "Night", "Both"]

    list_of_educations = ["High School Diploma/Hi-SET", "Certificate or Credential", "Associate's Degree", "Bachelor's Degree", "Master's Degree"]

    # define query
    query = ""
    regions_query = ""
    industries_query = ""
    tuition_query = ""
    financial_query = ""
    program_duration_query = ""
    hours_per_week_query = ""
    time_of_day_query = ""
    education_query = ""

    ## filter by region
    region_ids = params[:regions]
    if  region_ids && region_ids != ""
      region_ids = region_ids.split(',')

      query_temp = []
      region_ids.each do |id|
        query_temp << "'#{list_of_regions[id.to_i]}'"
      end

      query = " region IN (#{query_temp.join(',')}) "
    end

    ## filter by industry
    industry_ids = params[:industries]
    if industry_ids && industry_ids != ""
      industry_ids = industry_ids.split(',')

      industries_query = "("

      industry_ids.each_with_index do |id, index|

        if index == 0
          industries_query += "industries like '%#{list_of_clusters[id.to_i]}%'"
        else
          industries_query += " OR industries like '%#{list_of_clusters[id.to_i]}%'"
        end
      end
      industries_query += ")"

      if query == ""
        query = industries_query
      else
        query = query + " AND " + industries_query
      end
    end

    ## filter by tuition
    tuition_min = params[:cost_min]
    tuition_max = params[:cost_max]
    if tuition_max && tuition_max != "" && tuition_min && tuition_min != ""

      tuition_query = "("

      tuition_query += " tuition_max <= #{tuition_max} AND tuition_min >= #{tuition_min} "

      tuition_query += ")"

      if query == ""
        query = tuition_query
      else
        query = query + " AND " + tuition_query
      end
    end

    # filter by financial help
    finalcial_ids = params[:financials]
    if finalcial_ids && finalcial_ids != ""

      finalcial_ids = finalcial_ids.split(',')

      financial_query = "("

      finalcial_ids.each_with_index do |id, index|

        if index == 0
          financial_query += "financial_help like '%#{list_of_financials[id.to_i]}%'"
        else
          financial_query += " OR financial_help like '%#{list_of_financials[id.to_i]}%'"
        end
      end
      financial_query += ")"

      if query == "" && tuition_query == ""
        query = financial_query
      else
        query = query + " AND " + financial_query
      end
    end

    # filter by program duration
    program_duration_ids = params[:programs]
    if program_duration_ids && program_duration_ids != ""

      program_duration_ids = program_duration_ids.split(',')

      program_duration_query = "("

      program_duration_ids.each_with_index do |id, index|

        if index == 0
          program_duration_query += "duration like '%#{list_of_program_durations[id.to_i]}%'"
        else
          program_duration_query += " OR duration like '%#{list_of_program_durations[id.to_i]}%'"
        end
      end
      program_duration_query += ")"

      if query == "" && tuition_query == "" && financial_query == ""
        query = program_duration_query
      else
        query = query + " AND " + program_duration_query
      end
    end

    # filter by hour per week
    hour_per_week_ids = params[:hours]
    if hour_per_week_ids && hour_per_week_ids != ""

      hour_per_week_ids = hour_per_week_ids.split(',')

      hours_per_week_query = "("

      hour_per_week_ids.each_with_index do |id, index|

        if index == 0
          hours_per_week_query += "hours_per_weeks like '%#{list_of_hours_per_week[id.to_i]}%'"
        else
          hours_per_week_query += " OR hours_per_weeks like '%#{list_of_hours_per_week[id.to_i]}%'"
        end
      end
      hours_per_week_query += ")"

      if query == "" && tuition_query == "" && financial_query == "" && program_duration_query == ""
        query = hours_per_week_query
      else
        query = query + " AND " + hours_per_week_query
      end
    end

    # filter by time of day
    time_of_day_ids = params[:times]
    if time_of_day_ids && time_of_day_ids != ""

      time_of_day_ids = time_of_day_ids.split(',')

      time_of_day_query = "("

      time_of_day_ids.each_with_index do |id, index|

        if index == 0
          time_of_day_query += "time_of_day like '%#{list_of_time_of_day[id.to_i]}%'"
        else
          time_of_day_query += " OR time_of_day like '%#{list_of_time_of_day[id.to_i]}%'"
        end
      end
      time_of_day_query += ")"

      if query == "" && tuition_query == "" && financial_query == "" && program_duration_query == "" && hours_per_week_query == ""
        query = time_of_day_query
      else
        query = query + " AND " + time_of_day_query
      end
    end

    # filter by education
    education_ids = params[:educations]
    if education_ids && education_ids != ""

      education_ids = education_ids.split(',')

      education_query = "("

      education_ids.each_with_index do |id, index|

        if index == 0
          education_query += "education like '%#{list_of_educations[id.to_i].gsub!(/'/, "''")}%'"
        else
          education_query += " OR education like '%#{list_of_educations[id.to_i].gsub!(/'/, "''")}%'"
        end
      end
      education_query += ")"

      if query == "" && tuition_query == "" && financial_query == "" && program_duration_query == "" && hours_per_week_query == "" && time_of_day_query == ""
        query = education_query
      else
        query = query + " AND " + education_query
      end
    end

    ## seach by program title
    program_title = params[:title]
    if program_title && program_title != ""

      program_title = program_title.downcase

      title_query = "("

      title_query += " LOWER(title) like '%#{program_title}%' OR LOWER(institution_name) like '%#{program_title}%' "

      title_query += ")"

      if query == "" && tuition_query == "" && financial_query == "" && program_duration_query == "" && hours_per_week_query == "" && time_of_day_query == "" && education_query == ""
        query = title_query
      else
        query = query + " AND " + title_query
      end
    end

    last_id = 0
    if params[:last_id] && params[:last_id] != ""
      last_id = params[:last_id]

      query = query + " AND id > #{last_id} "
    end

    ## sort by
    sort_by = "id"
    if params[:sort] && params[:sort] != ""
      sort_by = params[:sort]
    end

    isSeeMore = false
    programs = Program.where(query).order(sort_by)

    if programs.length > 3
      isSeeMore = true
    end

    render :json => {
      :list => render_to_string('education/partial/_list', :layout => false, :locals => { programs: programs.first(3) }),
      :map => render_to_string('education/partial/_map', :layout => false, :locals => { programs: programs.first(3) }),
      :isSeeMore => isSeeMore,
      :programs => programs.first(3)
    }
  end
end
