class CareerController < ApplicationController
  def index
    @careers_slider = Career.first(5)

    @interests = Interest.all
    @list_of_interests = Hash.new
    @interests.each do |interest|
      @list_of_interests[interest[:name]] = interest[:url]
    end

    @skills = Skill.all
    @list_of_skills = Hash.new
    @skills.each do |skill|
      @list_of_skills[skill[:name]] = skill[:url]
    end

    @list_of_regions = Region.all
    @list_of_industries = Cluster.all
    @list_of_educations = Education.all
    @list_of_careers = Career.select(:title).map(&:title).uniq

    @careers = Career.first(6)
    @isSeeMore = false

    if Career.count > 6
      @isSeeMore = true
    end

  end

  def detail

    @careers = Career.where(:slug => params[:slug])
    @career = @careers.first

    if @career
      interests = Interest.all
      @list_of_interests = Hash.new
      interests.each do |interest|
        @list_of_interests[interest[:name]] = interest[:url]
      end

      skills = Skill.all
      @list_of_skills = Hash.new
      skills.each do |skill|
        @list_of_skills[skill[:name]] = skill[:url]
      end

      @regions = Hash.new
      @careers.map do |career|
        @regions[career.region] = {
          :salary_min => career.salary_min,
          :salary_max => career.salary_max,
          :education => career.education
        }
      end

      @related_by_skills = Career.where(title: @career.related_career_by_skill)
      @related_by_interests = Career.where(title: @career.related_career_by_interest)

      profileName = @career.profile_name
      @profile = Profile.where(:first_name => profileName.split(' ', 2).first, :last_name => profileName.split(' ', 2).last).first

      logger.debug @profile
      logger.debug @related_by_interests.count
    else
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
    logger.debug skills
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
    if region_ids != "" && region_ids
      region_ids = region_ids.split(',')
      logger.debug region_ids

      query_temp = []
      region_ids.each do |id|
        query_temp << "'#{list_of_regions[id.to_i]}'"
      end

      query = " region IN (#{query_temp.join(',')}) "
    end
    logger.debug "aaaaaa"
    logger.debug query

    ## filter by industry
    industry_ids = params[:industries]
    if industry_ids && industry_ids != ""
      industry_ids = industry_ids.split(',')
      logger.debug industry_ids

      industries_query = "("

      industry_ids.each_with_index do |id, index|

        logger.debug index == 0
        logger.debug index

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

        logger.debug index == 0
        logger.debug index

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
      logger.debug education_ids

      educations_query = "("

      education_ids.each_with_index do |id, index|

        logger.debug index == 0
        logger.debug index

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
      logger.debug interest_ids

      interests_query = "("

      interest_ids.each_with_index do |id, index|

        logger.debug index == 0
        logger.debug index

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
      logger.debug demand_ids

      demands_query = "("

      demand_ids.each_with_index do |id, index|

        logger.debug index == 0
        logger.debug index
        logger.debug id

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

      logger.debug salary_max
      logger.debug salary_min

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

      logger.debug career_title

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
    if params[:last_id] && params[:sort] != ""
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

    if careers.length > 6
      isSeeMore = true
    end

    render :json => {
      :careers => render_to_string('career/partial/_career', :layout => false, :locals => { careers: careers.first(6) }),
      :list => render_to_string('career/partial/_list', :layout => false, :locals => { careers: careers.first(6) }),
      :isSeeMore => isSeeMore
    }
    # render :partial => "career/partial/career", :locals => { careers: careers}
    # render :json => careers
  end
end
