# == Schema Information
#
# Table name: careers
#
#  id             :integer          not null, primary key
#  profile_id     :integer
#  title          :string
#  url            :string
#  description    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#

class Career < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_by_title, use: :slugged

  has_many :profile_careers, dependent: :destroy
  has_many :profiles, through: :profile_careers, source: :profile
  has_many :top_jobs

  has_many :career_regions
  has_many :regions, through: :career_regions, source: :region

  has_many :career_region_high_demands, dependent: :destroy
  has_many :regions_high_demand, through: :career_region_high_demands, source: :region

  has_many :career_interests, dependent: :destroy
  has_many :interests, through: :career_interests, source: :interest

  has_many :career_skills, dependent: :destroy
  has_many :skills, through: :career_skills, source: :skill

  has_many :career_clusters, dependent: :destroy
  has_many :industries, through: :career_clusters, source: :cluster

  has_many :career_skill_relationships, foreign_key: :career_id,
                                        class_name: 'CareerSkillship'
  has_many :related_by_skills, through: :career_skill_relationships,
                               source: :career_related

  has_many :career_interest_relationships, foreign_key: :career_id,
                                           class_name: 'CareerInterestship'
  has_many :related_by_interests, through: :career_interest_relationships,
                                  source: :career_related

  has_many :career_educations, dependent: :destroy
  has_many :educations, through: :career_educations, source: :education

  has_many :program_careers, dependent: :destroy
  has_many :programs, through: :program_careers, source: :program

  validates :title, presence: true
  validates :education, presence: true
  validates :about_job, presence: true
  validates :what_will_do, presence: true
  validates :photo_large, presence: true
  validates :photo_medium, presence: true

  validates :industries, presence: true
  validates :interests, presence: true
  validates :skills, presence: true
  validates :salary_min, presence: true
  validates :salary_max, presence: true
  validates :demand, presence: true
  validates :regions_high_demand, presence: true

  validates_uniqueness_of :title

  scope :filter_by_title, lambda { |title|
    where("(LOWER(title) like '%#{title.gsub(/'/, "''").downcase}%')")
  }

  scope :with_regions_high_demand, lambda {
    joins(:career_region_high_demands).distinct
  }

  scope :with_industries, lambda {
    joins(:career_clusters).distinct
  }

  scope :with_educations, lambda {
    joins(:career_educations).distinct
  }

  scope :with_interests, lambda {
    joins(:career_interests).distinct
  }

  scope :with_skills, lambda {
    joins(:career_skills).distinct
  }

  scope :filter_by_region, lambda { |region|
    with_regions_high_demand.where('career_region_high_demands.region_id IN (?)', region)
  }

  scope :filter_by_industry, lambda { |industry|
    with_industries.where('career_clusters.cluster_id IN (?)', industry)
  }

  scope :filter_by_education, lambda { |education|
    with_educations.where('career_educations.education_id IN (?)', education)
  }

  scope :filter_by_interest, lambda { |interest|
    with_interests.where('career_interests.interest_id IN (?)', interest)
  }

  scope :filter_by_skill, lambda { |skill|
    with_skills.where('career_skills.skill_id IN (?)', skill)
  }

  scope :filter_by_salary, lambda { |salary_min, salary_max|
    where.not('salary_max < ? OR salary_min > ?', salary_min, salary_max)
  }

  scope :salary_asc, -> { order(:salary_min) }
  scope :salary_desc, -> { order(salary_max: :desc) }

  scope :projected_growth_asc, -> { order(:projected_growth) }
  scope :projected_growth_desc, -> { order(projected_growth: :desc) }

  def self.import_from_csv(csv)
    Career.transaction do
      Career.delete_all
      CareerInterestship.delete_all
      CareerSkillship.delete_all
      CareerInterest.delete_all
      CareerSkill.delete_all
      CareerEducation.delete_all
      CareerRegionHighDemand.delete_all
      CareerCluster.delete_all

      csv.each do |row|
        title_str = row[0].strip
        next if Career.exists?(title: title_str)

        career = Career.new
        career[:title] = title_str

        career[:salary_min] = row[7].strip
        career[:salary_max] = row[8].strip
        career[:about_job] = row[10].strip
        career[:what_will_do] = row[11].strip
        career[:demand] = row[14].strip
        career[:photo_large] = row[15].strip if row[15].present?
        career[:photo_medium] = row[16].strip if row[16].present?
        career[:projected_growth] = row[19].strip if row[19].present?

        career.save!

        # Adding interests
        create_career_interests(row[6].split(',').map(&:strip), career) if row[6].present?

        # Adding skills
        create_career_skills(row[5].split(',').map(&:strip), career) if row[5].present?

        # Adding regions high demand
        if row[17].present?
          create_career_regions(row[17].split(',').map(&:strip), career)
        end

        # Adding educations
        if row[9].present?
          create_career_educations(row[9].split(',').map(&:strip), career)
        end

        # Adding industries
        (1..4).each do |i|
          create_career_cluster(row[i].strip, career) if row[i].present?
        end
      end

      csv.each do |row|
        career = Career.find_by_title(row[0].strip)

        # Adding related_career_by_skill
        if row[12].present?
          create_career_skillships(row[12].split(';').map(&:strip), career)
        end

        # Adding related_career_by_interest
        if row[13].present?
          create_career_interestships(row[13].split(';').map(&:strip), career)
        end
      end
    end
  end

  def self.create_career_interests(interests, career)
    interests.each do |interest_name|
      interest = Interest.find_by_name(interest_name)

      CareerInterest.create(
        career_id: career.id,
        interest_id: interest.present? ? interest.id : nil
      )
    end
  end

  def self.create_career_skills(skills, career)
    skills.each do |skill_name|
      skill = Skill.find_by_name(skill_name)

      CareerSkill.create(
        career_id: career.id,
        skill_id: skill.present? ? skill.id : nil
      )
    end
  end

  def self.create_career_educations(educations, career)
    educations.each do |education_name|
      education = Education.find_or_create(education_name)

      CareerEducation.create(
        career_id: career.id,
        education_id: education.id
      )
    end
  end

  def self.create_career_regions(regions, career)
    regions.each do |region_name|
      region = Region.find_region(region_name)

      CareerRegionHighDemand.create(
        career_id: career.id,
        region_id: region.present? ? region.id : nil
      )
    end
  end

  def self.create_career_interestships(careers, career)
    careers.each do |career_name|
      career_related = Career.find_by_title(career_name)

      CareerInterestship.create(
        career_id: career.id,
        career_related_id: career_related.present? ? career_related.id : nil
      )
    end
  end

  def self.create_career_skillships(careers, career)
    careers.each do |career_name|
      career_related = Career.find_by_title(career_name)

      CareerSkillship.create(
        career_id: career.id,
        career_related_id: career_related.present? ? career_related.id : nil
      )
    end
  end

  def self.create_career_cluster(cluster_name, career)
    cluster = Cluster.find_by_name(cluster_name)

    CareerCluster.create(
      career_id: career.id,
      cluster_id: cluster.present? ? cluster.id : nil
    )
  end

  def to_s
    title
  end

  private

  # Defaults a slug with title
  def slug_by_title
    "#{title.gsub(/[^a-zA-Z0-9]/, '-')}-#{id}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
