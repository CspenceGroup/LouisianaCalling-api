class CareerController < ApplicationController
  include CareerHelper
  before_action :data_for_filter_details, only: [:index]
  before_action :career_titles, only: [:index, :detail]

  def index
    @jobs = {}

    TopJob.all
          .valid
          .includes(:region, :career)
          .group_by(&:region).each do |region, top_jobs|
            # Sorting by title
            top_jobs = top_jobs.sort_by { |top_job| top_job.career.title.downcase }

            @jobs[region] = top_jobs.map do |top_job|
              {
                job: top_job.career.title,
                link: career_detail_path(top_job.career)
              }
            end
          end

    @limit = params[:limit] || 9
    @offset = params[:offset] || 0

    careers =
      if !params[:title].present? && !params[:region].present?
        Career.all.filter_by_salary(
          Constants::SALARY_MIN, Constants::SALARY_MAX
        )
      else
        careers = Career.all

        if params[:region].present?
          careers = careers.filter_by_region(params[:region].split(','))
        end

        careers = careers.filter_by_title(params[:title])
                         .filter_by_salary(
                           Constants::SALARY_MIN, Constants::SALARY_MAX
                         )
        careers
      end
    @limit = @limit.to_i
    @offset = @offset.to_i

    next_offset = @offset + @limit
    @is_see_more = careers.count > next_offset ? true : false

    careers = careers.high_demand

    @careers = Kaminari.paginate_array(careers).offset(@offset).limit(@limit)

    @title = params[:title]
    @region = params[:region]
    @offset = next_offset
  end

  def detail
    @career = Career.friendly.find(params[:slug])
    @list_of_careers = Career.select(:title).map(&:title).uniq
    @list_of_regions = Region.all.alphabetical

    return unless @career.present?

    @regions = get_regions_by_career(@career.id)
  end

  def filter
    careers = list_careers_by_query(params)
    @limit = params[:limit] || 9
    @offset = params[:offset] || 0

    @limit = @limit.to_i
    @offset = @offset.to_i
    ## seach by career title
    careers = careers.filter_by_title(params[:title]) if params[:title].present?

    ## Sort by
    if params[:sort].present?
      sort_by = params[:sort].to_i

      careers =
        case sort_by
        when 1 # Salary high to low
          careers.salary_desc
        when 2 # Salary low to high
          careers.salary_asc
        when 3 # Projected Growth high to low
          careers.projected_growth_desc
        when 4 # Projected Growth low to high
          careers.projected_growth_asc
        else
          Kaminari.paginate_array(careers.high_demand)
        end
    end

    next_offset = @limit + @offset
    is_see_more = careers.count > next_offset ? true : false

    careers = careers.offset(@offset).limit(@limit)

    render json: {
      careers: render_to_string(
        'career/partial/_career', layout: false, locals: { careers: careers }
      ),
      list: render_to_string(
        'career/partial/_list', layout: false, locals: { careers: careers }
      ),
      is_see_more: is_see_more,
      offset: next_offset,
      limit: @limit
    }
  end

  private

  def list_careers_by_query(params)
    careers = Career.all

    ## filter by region
    careers = careers.filter_by_region(params[:regions].split(',')) if params[:regions].present?

    ## filter by industry
    careers = careers.filter_by_industry(params[:industries].split(',')) if params[:industries].present?

    ## filter by skill
    careers = careers.filter_by_skill(params[:skills].split(',')) if params[:skills].present?

    ## filter by education
    if params[:educations].present?
      careers = careers.filter_by_education(params[:educations].split(','))
    end

    ## filter by interests
    careers = careers.filter_by_interest(params[:interests].split(',')) if params[:interests].present?

    ## filter by demand
    if params[:demand].present?
      careers = careers.where('demand IN (?)', params[:demand].split(','))
    end

    ## filter by salary
    if params[:salary_max].present? && params[:salary_min].present?
      careers = careers.filter_by_salary(params[:salary_min], params[:salary_max])
    end

    careers
  end

  def data_for_filter_details
    @list_of_regions = Region.all.alphabetical
    @list_of_industries = Cluster.all.alphabetical
    @list_of_educations = Education.all.alphabetical
    @skills = Skill.all.alphabetical
    @interests = Interest.all.alphabetical
  end

  def career_titles
    @list_of_careers = Career.all.map(&:title).uniq
  end
end
