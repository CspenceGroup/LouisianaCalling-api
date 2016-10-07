module ApplicationHelper
  # Convert list interests to hash
  def convert_interests_to_hash
    interests = Interest.all.map do |interest|
      [interest.id, interest.name]
    end
    interests.to_h
  end

  # Convert list regions to hash
  def convert_regions_to_hash
    regions = Region.all.map do |region|
      [region.id, region.name]
    end
    regions.to_h
  end

  # Convert list industries to hash
  def convert_industries_to_hash
    industries = Cluster.all.map do |cluster|
      [cluster.id, cluster.name]
    end
    industries.to_h
  end

  # Convert list skills to hash
  def convert_skills_to_hash
    skills = Skill.all.map do |skill|
      [skill.id, skill.name]
    end
    skills.to_h
  end

  # Convert list educations to hash
  def convert_educations_to_hash
    educations = Education.all.map do |education|
      [education.id, education.name]
    end
    educations.to_h
  end
end
