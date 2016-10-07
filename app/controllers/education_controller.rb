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
    query = []

    ## filter by region
    query.push(regions_query_str(params[:regions])) if params[:regions].present?

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
    if params[:programs].present?
      query.push(programs_query_str(params[:programs]))
    end

    # filter by hour per week
    query.push(hours_query_str(params[:hours])) if params[:hours].present?

    # filter by time of day
    query.push(times_query_str(params[:times])) if params[:times].present?

    # filter by education
    if params[:educations].present?
      query.push(educations_query_str(params[:educations]))
    end

    ## seach by program title
    if params[:title].present?
      title = params[:title].downcase

      str_query = [
        "LOWER(title) like '%#{title}%'",
        "LOWER(institution_name) like '%#{title}%'",
        "LOWER(career) like '%#{title}%'"
      ]

      query.push(str_query.join(' OR '))
    end

    query.push("id > #{params[:last_id]}") if params[:last_id].present?

    ## Sort by, defaut sort by ID
    sort_by = params[:sort].present? ? params[:sort] : 'id'

    programs = Program.where(query.join(' AND ')).order(sort_by)
    ids = programs.map(&:id)

    is_see_more = programs.length > 3 ? true : false
    programs = programs.offset(0).limit(3)
    render json: {
      list: render_to_string(
        'education/partial/_list', layout: false, locals: { programs: programs }
      ),
      map: render_to_string(
        'education/partial/_map', layout: false, locals: {
          programs: programs,
          ids: ids
        }
      ),
      is_see_more: is_see_more,
      programs: programs,
      ids: ids
    }
  end

  private

  def data_for_filter_details
    @list_of_regions = Region.all
    @list_of_industries = Cluster.all
    @list_of_programs = Program.select(:title).map(&:title).uniq
  end
end
