class EducationController < ApplicationController
  include ProgramHelper

  before_filter :data_for_filter_details, only: [:index]

  def index
    limit = 3
    @title = params[:title]
    @region = params[:region]

    list_programs =
      if !params[:title].present? && !params[:region].present?
        Program.all
               .filter_by_tuition(
                 Constants::TUITION_MIN, Constants::TUITION_MAX
               )
      else
        programs = Program.all
        programs =
          if params[:title].present?
            programs.filter_by_title(params[:title])
          else
            programs.filter_by_regions(params[:region].split(','))
          end

        programs = programs.filter_by_tuition(
                    Constants::TUITION_MIN, Constants::TUITION_MAX
                  )
        programs
      end

    @is_see_more = list_programs.count > limit ? true : false
    @programs = list_programs.offset(0).limit(limit)
    @ids = list_programs.map(&:id)
  end

  def detail
    @program = Program.friendly.find(params[:slug])
  end

  def filter
    programs = Program.all

    ## filter by region
    programs = programs.filter_by_regions(params[:regions].split(',')) if params[:regions].present?

    ## filter by industry
    if params[:industries].present?
      programs = programs.filter_by_industries(params[:industries].split(','))
    end

    ## filter by tuition
    tuition_min = params[:cost_min]
    tuition_max = params[:cost_max]
    if tuition_max.present? && tuition_min.present?
      programs = programs.filter_by_tuition(tuition_min, tuition_max)
    end

    ## seach by program title
    if params[:title].present?
      programs = programs.filter_by_title(params[:title])
    end

    # filter by education
    if params[:educations].present?
      programs = programs.filter_by_educations(params[:educations].split(','))
    end

    query = []

    # filter by program duration
    if params[:programs].present?
      query.push(programs_query_str(params[:programs]))
    end

    # filter by hour per week
    query.push(hours_query_str(params[:hours])) if params[:hours].present?

    # filter by time of day
    query.push(times_query_str(params[:times])) if params[:times].present?

    programs = programs.where(query.join(' AND '))
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
    @list_of_educations = Education.all
    @list_of_programs = Program.select(:title).map(&:title).uniq
  end
end
