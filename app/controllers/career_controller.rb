class CareerController < ApplicationController
  include CareerHelper
  before_filter :data_for_filter_details, only: [:index]
  before_filter :career_titles, only: [:index, :detail]

  def index
    @careers_slider = Career.first(5)

    # Career.first(5).each do |career|
    #   # get_image_for_career_interest is invoked from CareerHelper
    #   # career.interests = get_image_for_career_interest(career.interests)
    #   # get_image_for_career_skill is invoked from CareerHelper
    #   # career.skills = get_image_for_career_skill(career.skills)
    #   @careers_slider << career
    # end
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

    @careers = careers.offset(0).limit(9)
    @title = params[:title]
    @region = params[:region]
    @is_see_more = careers.count > 9 ? true : false
  end

  def detail
    @career = Career.friendly.find(params[:slug])
    @list_of_careers = Career.select(:title).map(&:title).uniq
    @list_of_regions = Region.all

    return unless @career.present?

    @regions = get_regions_by_career(@career.id)
  end

  def filter
    careers = list_careers_by_query(params)

    ## seach by career title
    careers = careers.filter_by_title(params[:title]) if params[:title].present?

    ## Sort by, defaut sort by ID
    sort_by = params[:sort].present? ? params[:sort] : 'id'
    careers = careers.order(sort_by)

    is_see_more = careers.count > 9 ? true : false
    careers = careers.offset(0).limit(9)

    render json: {
      careers: render_to_string(
        'career/partial/_career', layout: false, locals: { careers: careers }
      ),
      list: render_to_string(
        'career/partial/_list', layout: false, locals: { careers: careers }
      ),
      is_see_more: is_see_more
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
    @list_of_regions = Region.all
    @list_of_industries = Cluster.all
    @list_of_educations = Education.all
    @skills = Skill.all
    @interests = Interest.all
  end

  def career_titles
    @list_of_careers = Career.all.map(&:title).uniq
  end
end
