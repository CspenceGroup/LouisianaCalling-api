module CareerHelper
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
end
