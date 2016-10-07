module ApplicationHelper
  # Convert list interests to hash
  def convert_interests_to_hash
    interests = Interest.all.map do |interest|
      [interest.id, interest.name.gsub(/'/, "''")]
    end
    interests.to_h
  end

  # Convert list regions to hash
  def convert_regions_to_hash
    regions = Region.all.map do |region|
      [region.id, region.name.gsub(/'/, "''")]
    end
    regions.to_h
  end

  # Convert list industries to hash
  def convert_industries_to_hash
    industries = Cluster.all.map do |cluster|
      [cluster.id, cluster.name.gsub(/'/, "''")]
    end
    industries.to_h
  end

  # Convert list skills to hash
  def convert_skills_to_hash
    skills = Skill.all.map do |skill|
      [skill.id, skill.name.gsub(/'/, "''")]
    end
    skills.to_h
  end

  # Convert list educations to hash
  def convert_educations_to_hash
    educations = Education.all.map do |education|
      [education.id, education.name.gsub(/'/, "''")]
    end
    educations.to_h
  end

  # Get industries query string
  def industries_query_str(industry_ids)
    industry_ids = industry_ids.split(',')
    list_of_clusters = convert_industries_to_hash
    industries_q = ['(']

    industry_ids.each_with_index do |id, index|
      if index.zero?
        industries_q.push "industries like '%#{list_of_clusters[id.to_i]}%'"
      else
        industries_q.push " OR industries like '%#{list_of_clusters[id.to_i]}%'"
      end
    end
    industries_q.push ')'

    industries_q.join('')
  end

  # Get educations query string
  def educations_query_str(education_ids)
    education_ids = education_ids.split(',')
    list_of_educations = convert_educations_to_hash
    edu_query = ['(']

    education_ids.each_with_index do |id, index|
      if index.zero?
        edu_query.push "education like '%#{list_of_educations[id.to_i]}%'"
      else
        edu_query.push " OR education like '%#{list_of_educations[id.to_i]}%'"
      end
    end
    edu_query.push ')'

    edu_query.join('')
  end
end
