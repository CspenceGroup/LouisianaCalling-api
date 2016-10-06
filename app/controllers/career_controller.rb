class CareerController < ApplicationController
  include CareerHelper

  def index
    @careers_slider = Career.first(5)

    @interests = Interest.all
    @list_of_interests = {}
    @interests.each do |interest|
      @list_of_interests[interest[:name]] = interest[:url]
    end

    @skills = Skill.all
    @list_of_skills = {}
    @skills.each do |skill|
      @list_of_skills[skill[:name]] = skill[:url]
    end

    @list_of_regions = Region.all
    @list_of_industries = Cluster.all
    @list_of_educations = Education.all
    @list_of_careers = Career.select(:title).map(&:title).uniq

    salary_min = 30000;
    salary_max = 80000;

    if !params["title"] && !params["region"]
      @careers = Career.where("salary_max <= #{salary_max} AND salary_min >= #{salary_min}").first(9)
      @isSeeMore = false

      if Career.where("salary_max <= #{salary_max} AND salary_min >= #{salary_min}").count > 9
        @isSeeMore = true
      end
    else
      @title = params["title"].downcase if params["title"]
      @region = params["region"]

      @careers = Career.where("LOWER(title) like '%#{@title}%' AND regions_high_demand like '%#{@region}%' AND salary_max <= #{salary_max} AND salary_min >= #{salary_min} ").first(9)
      @isSeeMore = false

      if Career.where("LOWER(title) like '%#{@title}%' AND regions_high_demand like '%#{@region}%' AND salary_max <= #{salary_max} AND salary_min >= #{salary_min} ").count > 9
        @isSeeMore = true
      end
    end
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

    ## get list of skills
    skills = Skill.all
    list_of_skills = []
    skills.each do |skill|
      list_of_skills[skill[:id]] = skill[:name]
    end

    ## get list of educations
    educations = Education.all
    list_of_educations = []
    educations.each do |education|
      list_of_educations[education[:id]] = education[:name]
    end

    ## get list of interests
    interests = Interest.all
    list_of_interests = []
    interests.each do |interest|
      list_of_interests[interest[:id]] = interest[:name]
    end

    # define query
    query = ""
    regions_query = ""
    industries_query = ""
    skills_query = ""
    educations_query = ""
    interests_query = ""
    demands_query = ""
    salary_query = ""
    title_query = ""

    ## filter by region
    region_ids = params[:regions]
    if region_ids && region_ids != ""
      region_ids = region_ids.split(',')

      regions_query = "("
      region_ids.each_with_index do |id, index|

        if index == 0
          regions_query += "regions_high_demand like '%#{list_of_regions[id.to_i]}%'"
        else
          regions_query += " OR regions_high_demand like '%#{list_of_regions[id.to_i]}%'"
        end
      end
      regions_query += ")"

      query = regions_query

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
        query = regions_query + " AND " + industries_query
      end
    end

    ## filter by industry
    skill_ids = params[:skills]

    if skill_ids && skill_ids != ""
      skill_ids = skill_ids.split(',')

      skills_query = "("

      skill_ids.each_with_index do |id, index|

        if index == 0
          skills_query += "skills like '%#{list_of_skills[id.to_i]}%'"
        else
          skills_query += " OR skills like '%#{list_of_skills[id.to_i]}%'"
        end
      end
      skills_query += ")"

      if query == "" && industries_query == ""
        query = skills_query
      else
        query = query + " AND " + skills_query
      end
    end

    ## filter by education
    education_ids = params[:educations]
    if education_ids && education_ids != ""
      education_ids = education_ids.split(',')

      educations_query = "("

      education_ids.each_with_index do |id, index|

        if index == 0
          educations_query += "education like '%#{list_of_educations[id.to_i]}%'"
        else
          educations_query += " OR education like '%#{list_of_educations[id.to_i]}%'"
        end
      end
      educations_query += ")"

      if query == "" && industries_query == "" && skills_query == ""
        query = educations_query
      else
        query = query + " AND " + educations_query
      end
    end

    ## filter by interests
    interest_ids = params[:interests]
    if interest_ids && interest_ids != ""
      interest_ids = interest_ids.split(',')

      interests_query = "("

      interest_ids.each_with_index do |id, index|

        if index == 0
          interests_query += "interests like '%#{list_of_interests[id.to_i]}%'"
        else
          interests_query += " OR interests like '%#{list_of_interests[id.to_i]}%'"
        end
      end
      interests_query += ")"

      if query == "" && industries_query == "" && skills_query == "" && educations_query == ""
        query = interests_query
      else
        query = query + " AND " + interests_query
      end
    end

    ## filter by demand
    demand_ids = params[:demands]
    if demand_ids && demand_ids != ""
      demand_ids = demand_ids.split(',')

      demands_query = "("

      demand_ids.each_with_index do |id, index|

        if index == 0
          demands_query += " demand = #{id.to_i} "
        else
          demands_query += " OR demand = #{id.to_i} "
        end
      end
      demands_query += ")"

      if query == "" && industries_query == "" && skills_query == "" && educations_query == "" && interests_query == ""
        query = demands_query
      else
        query = query + " AND " + demands_query
      end
    end

    ## filter by salary
    salary_min = params[:salary_min]
    salary_max = params[:salary_max]
    if salary_max && salary_max != "" && salary_min && salary_min != ""

      salary_query = "("

      salary_query += " salary_max <= #{salary_max} AND salary_min >= #{salary_min} "

      salary_query += ")"

      if query == "" && industries_query == "" && skills_query == "" && educations_query == "" && interests_query == "" && demands_query == ""
        query = salary_query
      else
        query = query + " AND " + salary_query
      end
    end

    ## seach by career title
    career_title = params[:title]
    if career_title && career_title != ""

      career_title = career_title.downcase

      title_query = "("

      title_query += " LOWER(title) like '%#{career_title}%' "

      title_query += ")"

      if query == "" && industries_query == "" && skills_query == "" && educations_query == "" && interests_query == "" && demands_query == "" && salary_query == ""
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
    careers = Career.where(query).order(sort_by)

    if careers.length > 9
      isSeeMore = true
    end

    render :json => {
      :careers => render_to_string('career/partial/_career', :layout => false, :locals => { careers: careers.first(9) }),
      :list => render_to_string('career/partial/_list', :layout => false, :locals => { careers: careers.first(9) }),
      :isSeeMore => isSeeMore
    }
    # render :partial => "career/partial/career", :locals => { careers: careers}
    # render :json => careers
  end
end
