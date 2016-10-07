module CareerHelper
  include ApplicationHelper
  # Get image URL for each interest
  def get_image_for_career_interest(career_interests)
    interests =
      Interest.all
              .map { |interest| [interest.name, interest.url] }
              .to_h

    my_interests = career_interests.map do |interest|
      [interest, interests[interest]]
    end

    my_interests
  end

  # Get image URL for each skill
  def get_image_for_career_skill(career_skills)
    skills =
      Skill.all
           .map { |skill| [skill.name, skill.url] }
           .to_h

    my_skills = career_skills.map do |skill|
      [skill, skills[skill]]
    end

    my_skills
  end

  # Get career region info by career title
  def get_career_regions_by_career_title(career_title)
    career_regions = CareerRegion.where(title: career_title)
    regions = []

    if career_regions.present?
      regions = career_regions.map do |career_region|
        [career_region.region, {
          salary_min: career_region.salary_min,
          salary_max: career_region.salary_max,
          education: career_region.education
        }]
      end
    end

    regions.uniq.to_h
  end

  def regions_query_str(region_ids)
    region_ids = region_ids.split(',')
    list_of_regions = convert_regions_to_hash
    regions_query = ['(']

    region_ids.each_with_index do |id, index|
      if index.zero?
        regions_query.push "regions_high_demand like '%#{list_of_regions[id.to_i]}%'"
      else
        regions_query.push " OR regions_high_demand like '%#{list_of_regions[id.to_i]}%'"
      end
    end
    regions_query.push ')'

    regions_query.join('')
  end

  def skills_query_str(skill_ids)
    skill_ids = skill_ids.split(',')
    list_of_skills = convert_skills_to_hash
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

  def interests_query_str(interest_ids)
    interest_ids = interest_ids.split(',')
    list_of_interests = convert_interests_to_hash
    interests_q = ['(']

    interest_ids.each_with_index do |id, index|
      if index.zero?
        interests_q.push "interests like '%#{list_of_interests[id.to_i]}%'"
      else
        interests_q.push " OR interests like '%#{list_of_interests[id.to_i]}%'"
      end
    end
    interests_q.push ')'

    interests_q.join('')
  end

  def demands_query_str(demand_ids)
    demand_ids = demand_ids.split(',')
    demands_query = ['(']

    demand_ids.each_with_index do |id, index|
      if index.zero?
        demands_query.push "demand = #{id.to_i}"
      else
        demands_query.push " OR demand = #{id.to_i}"
      end
    end
    demands_query.push ')'

    demands_query.join('')
  end
end
