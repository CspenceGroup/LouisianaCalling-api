class CareerController < ApplicationController
  include CareerHelper
  before_filter :data_for_filter_details, only: [:index]
  before_filter :career_titles, only: [:index, :detail]

  def index
    @careers_slider = []

    Career.first(5).each do |career|
      # get_image_for_career_interest is invoked from CareerHelper
      career.interests = get_image_for_career_interest(career.interests)
      # get_image_for_career_skill is invoked from CareerHelper
      career.skills = get_image_for_career_skill(career.skills)
      @careers_slider << career
    end
    careers =
      if !params[:title].present? && !params[:region].present?
        Career.all.filter_by_salary(
          Constants::SALARY_MIN, Constants::SALARY_MAX
        )
      else
        Career.all
              .filter_by_title_and_region(params[:title], params[:region])
              .filter_by_salary(
                Constants::SALARY_MIN, Constants::SALARY_MAX
              )
      end

    @careers = careers.offset(0).limit(9)
    @isSeeMore = careers.count > 9 ? true : false
  end

  def detail
    @career = Career.friendly.find(params[:slug])
    @list_of_careers = Career.select(:title).map(&:title).uniq
    @list_of_regions = Region.all

    return unless @career.present?
    # get_image_for_career_interest is invoked from CareerHelper
    @career.interests = get_image_for_career_interest(@career.interests)

    # get_image_for_career_skill is invoked from CareerHelper
    @career.skills = get_image_for_career_skill(@career.skills)

    # get_career_regions_by_career_title is invoked from CareerHelper
    @regions = get_career_regions_by_career_title(@career.title)

    @related_by_skills = Career.all
                               .filter_by_title(@career.related_career_by_skill)
                               .offset(0).limit(3)

    @related_by_interests =
      Career.all
            .filter_by_title(@career.related_career_by_interest)
            .offset(0).limit(3)

    if @career.profile_name.present?
      @profile = Profile.find_by_full_name(@career.profile_name).first
    end
  end

  def filter
    query = convert_query_str(params)

    ## seach by career title
    if params[:title].present?
      query.push("(LOWER(title) like '%#{params[:title].downcase}%')")
    end

    last_id = params[:last_id].present? ? params[:last_id] : 0
    query.push("id > #{last_id}")

    ## Sort by, defaut sort by ID
    sort_by = params[:sort].present? ? params[:sort] : 'id'

    careers = Career.all.where(query.join(' AND ')).order(sort_by)
    is_see_more = careers.count > 9 ? true : false
    careers = careers.offset(0).limit(9)

    render json: {
      careers: render_to_string(
        'career/partial/_career', layout: false, locals: { careers: careers }
      ),
      list: render_to_string(
        'career/partial/_list', layout: false, locals: { careers: careers }
      ),
      isSeeMore: is_see_more
    }
  end

  private

  def convert_query_str(params)
    query = []
    ## filter by region
    query.push(regions_query_str(params[:regions])) if params[:regions].present?

    ## filter by industry
    if params[:industries].present?
      query.push(industries_query_str(params[:industries]))
    end

    ## filter by industry
    query.push(skills_query_str(params[:skills])) if params[:skills].present?

    ## filter by education
    if params[:educations].present?
      query.push(educations_query_str(params[:educations]))
    end

    ## filter by interests
    if params[:interests].present?
      query.push(interests_query_str(params[:interests]))
    end

    ## filter by demand
    query.push(demands_query_str(params[:demands])) if params[:demands].present?

    ## filter by salary
    if params[:salary_max].present? && params[:salary_min].present?
      salary_query = ["salary_max <= #{params[:salary_max]}"]
      salary_query.push "salary_min >= #{params[:salary_min]}"

      query.push(salary_query)
    end

    query
  end

  def regions_query_str(region_ids)
    region_ids = region_ids.split(',')
    ## get list of region
    list_of_regions = Region.all.map { |region| [region.id, region.name] }
    list_of_regions = list_of_regions.to_h
    regions_query = ['(']
    region_ids.each_with_index do |id, index|
      if index.zero?
        regions_query.push "region like '%#{list_of_regions[id.to_i]}%'"
      else
        regions_query.push " OR region like '%#{list_of_regions[id.to_i]}%'"
      end
    end
    regions_query.push ')'

    regions_query.join('')
  end

  def industries_query_str(industry_ids)
    industry_ids = industry_ids.split(',')
    ## get list of industries
    list_of_clusters = Cluster.all.map do |industry|
      [industry.id, industry.name]
    end
    list_of_clusters = list_of_clusters.to_h
    industries_query = ['(']

    industry_ids.each_with_index do |id, index|
      if index.zero?
        industries_query.push "industries like '%#{list_of_clusters[id.to_i]}%'"
      else
        industries_query.push " OR industries like '%#{list_of_clusters[id.to_i]}%'"
      end
    end
    industries_query.push ')'

    industries_query.join('')
  end

  def skills_query_str(skill_ids)
    skill_ids = skill_ids.split(',')
    ## get list of skills
    list_of_skills = Skill.all.map { |skill| [skill.id, skill.name] }
    list_of_skills = list_of_skills.to_h
    skills_query = ['(']
    skill_ids.each_with_index do |id, index|
      if index.zero?
        skills_query.push "skills like '%#{list_of_skills[id.to_i]}%'"
      else
        skills_query.push " OR skills like '%#{list_of_skills[id.to_i]}%'"
      end
    end
    skills_query.push ')'

    skills_query.join('')
  end

  def educations_query_str(education_ids)
    education_ids = education_ids.split(',')
    educations_query = ['(']

    ## get list of educations
    list_of_educations = Education.all.map do |education|
      [education.id, education.name]
    end
    list_of_educations = list_of_educations.to_h

    education_ids.each_with_index do |id, index|
      if index.zero?
        educations_query.push "education like '%#{list_of_educations[id.to_i]}%'"
      else
        educations_query.push " OR education like '%#{list_of_educations[id.to_i]}%'"
      end
    end
    educations_query.push ')'

    educations_query.join('')
  end

  def interests_query_str(interest_ids)
    interest_ids = interest_ids.split(',')
    interests_query = ['(']

    ## get list of interests
    list_of_interests = Interest.all.map  do |interest|
      [interest.id, interest.name]
    end
    list_of_interests = list_of_interests.to_h

    interest_ids.each_with_index do |id, index|
      if index.zero?
        interests_query.push "interests like '%#{list_of_interests[id.to_i]}%'"
      else
        interests_query.push " OR interests like '%#{list_of_interests[id.to_i]}%'"
      end
    end
    interests_query.push ')'

    interests_query.join('')
  end

  def demands_query_str(demand_ids)
    demand_ids = demand_ids.split(',')

    demands_query = ['(']

    demand_ids.each_with_index do |id, index|
      if index.zero?
        demands_query.push " demand = #{id.to_i} "
      else
        demands_query.push " OR demand = #{id.to_i} "
      end
    end
    demands_query.push ')'

    demands_query.join('')
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
