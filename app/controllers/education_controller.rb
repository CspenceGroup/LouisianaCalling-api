class EducationController < ApplicationController
  include ProgramHelper

  before_action :data_for_filter_details, only: [:index]

  def index
    @limit = params[:limit] || 3
    @offset = params[:offset] || 0

    @title = params[:title]
    @region = params[:region]

    programs = Program.all.filter_by_tuition(
      Constants::TUITION_MIN, Constants::TUITION_MAX
    )

    if params[:title].present?
      programs = programs.filter_by_title(params[:title])
    end

    if params[:region].present?
      programs = programs.filter_by_regions(params[:region].split(','))
    end

    @limit = @limit.to_i
    @offset = @offset.to_i

    next_offset = @offset + @limit
    @is_see_more = programs.count > next_offset ? true : false

    @programs = programs.recent.offset(@offset).limit(@limit)

    @offset = next_offset
  end

  def detail
    @program = Program.friendly.find(params[:slug])
  end

  def filter
    programs = Program.all

    @limit = params[:limit] || 9
    @offset = params[:offset] || 0

    ## filter by region
    if params[:regions].present?
      programs = programs.filter_by_regions(params[:regions].split(','))
    end

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

    @limit = @limit.to_i
    @offset = @offset.to_i

    next_offset = @limit + @offset
    is_see_more = programs.count > next_offset ? true : false

    programs = programs.recent.offset(@offset).limit(@limit)

    render json: {
      list: render_to_string(
        'education/partial/_list', layout: false, locals: { programs: programs }
      ),
      map: render_to_string(
        'education/partial/_map', layout: false, locals: {
          programs: programs,
          offset: @offset
        }
      ),
      is_see_more: is_see_more,
      programs: programs,
      limit: @limit,
      offset: next_offset
    }
  end

  private

  def data_for_filter_details
    @list_of_regions = Region.all.alphabetical
    @list_of_industries = Cluster.all.alphabetical
    @list_of_educations = Education.all.alphabetical

    @list_of_programs = Program.all.select(:title).map(&:title).uniq
    @list_of_programs.push(Program.all.select(:institution_name).map(&:institution_name).uniq)
    @list_of_programs.push(Career.all.select(:title).map(&:title).uniq)

    @list_of_programs = @list_of_programs.flatten
  end
end
