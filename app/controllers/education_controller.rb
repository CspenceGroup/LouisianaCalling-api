class EducationController < ApplicationController
  def index
  end

  def detail
  end

  def filter
    ## get list of industries
    clusters = Cluster.all
    list_of_clusters = []
    clusters.each do |cluster|
      list_of_clusters[cluster[:id]] = cluster[:name]
    end

    list_of_financials = ["Scholarship", "Financial Aid/Grant"]

    list_of_program_durations = ["8 Weeks", "3 Months", "6 Months", "1 Year", "2 Years", "4 Years"]

    list_of_hours_per_week = ["3 - 10 Hours", "11 - 20 Hours", "21 - 30 Hours", "31 - 40 Hours"]

    list_of_time_of_day = ["Day Time Only", "Night Time Only", "Full Day"]

    list_of_educations = ["High School Diploma/GED", "JumpStart", "Training", "College"]

    # define query
    query = ""
    industries_query = ""
    tuition_query = ""
    financial_query = ""
    program_duration_query = ""
    hours_per_week_query = ""
    time_of_day_query = ""
    education_query = ""

    ## filter by industry
    industry_ids = params[:industries]
    if industry_ids && industry_ids != ""
      industry_ids = industry_ids.split(',')
      logger.debug industry_ids

      industries_query = "("

      industry_ids.each_with_index do |id, index|

        if index == 0
          industries_query += "industries like '%#{list_of_clusters[id.to_i]}%'"
        else
          industries_query += " OR industries like '%#{list_of_clusters[id.to_i]}%'"
        end
      end
      industries_query += ")"

      query = industries_query
    end

    ## filter by tuition
    tuition_min = params[:tuition_min]
    tuition_max = params[:tuition_max]
    if tuition_max && tuition_max != "" && tuition_min && tuition_min != ""

      logger.debug tuition_max
      logger.debug tuition_min

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
    finalcial_ids = params[:finalcial]
    if finalcial_ids && finalcial_ids != ""

      finalcial_ids = finalcial_ids.split(',')
      logger.debug finalcial_ids

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
    program_duration_ids = params[:program_duration]
    if program_duration_ids && program_duration_ids != ""

      program_duration_ids = program_duration_ids.split(',')
      logger.debug program_duration_ids

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
    hour_per_week_ids = params[:hours_per_week]
    if hour_per_week_ids && hour_per_week_ids != ""

      hour_per_week_ids = hour_per_week_ids.split(',')
      logger.debug hour_per_week_ids

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

    # filter by hour per week
    time_of_day_ids = params[:time_of_day]
    if time_of_day_ids && time_of_day_ids != ""

      time_of_day_ids = time_of_day_ids.split(',')
      logger.debug time_of_day_ids

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

    # filter by hour per week
    education_ids = params[:education]
    if education_ids && education_ids != ""

      education_ids = education_ids.split(',')
      logger.debug education_ids

      education_query = "("

      education_ids.each_with_index do |id, index|

        if index == 0
          education_query += "education like '%#{list_of_educations[id.to_i]}%'"
        else
          education_query += " OR education like '%#{list_of_educations[id.to_i]}%'"
        end
      end
      education_query += ")"

      if query == "" && tuition_query == "" && financial_query == "" && program_duration_query == "" && hours_per_week_query == "" && time_of_day_query == ""
        query = education_query
      else
        query = query + " AND " + education_query
      end
    end

    last_id = 0
    if params[:last_id]
      last_id = params[:last_id]

      query = query + " AND id > #{last_id} "
    end

    logger.debug query

    programs = Program.where(query).order("id")

    if programs.length > 9
      isSeeMore = true
    end

    render :json => programs
  end
end
