class EducationController < ApplicationController
  include ProgramHelper

  before_filter :data_for_filter_details, only: [:index]

  def index
    limit = 3
    list_programs =
      if !params['title'].present? && !params['region'].present?
        Program.all
               .filter_by_tuition(
                 Constants::TUITION_MIN, Constants::TUITION_MAX
               )
      else
        Program.all
               .filter_by_title(params['title'])
               .filter_by_region(params['region'])
               .filter_by_tuition(
                 Constants::TUITION_MIN, Constants::TUITION_MAX
               )
      end

    @is_see_more = list_programs.count > limit ? true : false
    @programs = list_programs.offset(0).limit(limit)
    @ids = list_programs.map(&:id)
  end

  def detail
    @program = Program.friendly.find(params[:slug])
  end

  def filter
    # define query
    query = ""
    regions_query = ""
    industries_query = ""
    tuition_query = ""
    program_duration_query = ""
    hours_per_week_query = ""
    time_of_day_query = ""
    education_query = ""

    ## filter by region
    if  params[:regions].present?
      query.push(regions_query_str(params[:regions]))
    end

    ## filter by industry
    if params[:industries].present?
      query.push(industries_query_str(params[:industries]))
    end

    ## filter by tuition
    tuition_min = params[:cost_min]
    tuition_max = params[:cost_max]
    if tuition_max.present? && tuition_min.present?
      tuition_query = ["tuition_max <= #{tuition_max}"]
      tuition_query.push("tuition_min >= #{tuition_min}")

      query.push(tuition_query)
    end

    # filter by program duration
    program_duration_ids = params[:programs]
    if params[:programs].present?
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

      if query == "" && tuition_query == ""
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

      if query == "" && tuition_query == "" && program_duration_query == ""
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

      if query == "" && tuition_query == "" && program_duration_query == "" && hours_per_week_query == ""
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
        education = list_of_educations[id.to_i]

        if education.include? "'"
          education = education.gsub!(/'/, "''")
        end

        if index == 0
          education_query += "education like '%#{education}%'"
        else
          education_query += " OR education like '%#{education}%'"
        end
      end
      education_query += ")"

      if query == "" && tuition_query == "" && program_duration_query == "" && hours_per_week_query == "" && time_of_day_query == ""
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

      title_query += " LOWER(title) like '%#{program_title}%' OR LOWER(institution_name) like '%#{program_title}%' OR LOWER(career) like '%#{program_title}%'"

      title_query += ")"

      if query == "" && tuition_query == "" && program_duration_query == "" && hours_per_week_query == "" && time_of_day_query == "" && education_query == ""
        query = title_query
      else
        query = query + " AND " + title_query
      end
    end

    ## sort by
    sort_by = "id"
    if params[:sort] && params[:sort] != ""
      sort_by = params[:sort]
    end

    programs = Program.where(query).order(sort_by)
    ids = programs.map(&:id)

    last_id = 0
    if params[:last_id] && params[:last_id] != ""
      last_id = params[:last_id]

      query = query + " AND id > #{last_id} "
    end

    isSeeMore = false
    programs = Program.where(query).order(sort_by)

    if programs.length > 3
      isSeeMore = true
    end

    render :json => {
      :list => render_to_string('education/partial/_list', :layout => false, :locals => { programs: programs.first(3) }),
      :map => render_to_string('education/partial/_map', :layout => false, :locals => { programs: programs.first(3), ids: ids }),
      :isSeeMore => isSeeMore,
      :programs => programs.first(3),
      :ids => ids
    }
  end

  private

  def data_for_filter_details
    @list_of_regions = Region.all
    @list_of_industries = Cluster.all
    @list_of_programs = Program.select(:title).map(&:title).uniq
  end
end
