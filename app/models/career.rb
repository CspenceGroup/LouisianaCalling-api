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

  before_destroy :delete_top_job

  validates :title, presence: true
  validates :about_job, presence: true
  validates :what_will_do, presence: true
  validates :photo_large, presence: true
  validates :photo_medium, presence: true

  validates :salary_min, presence: true
  validates :salary_max, presence: true
  validates :demand, presence: true

  validates_uniqueness_of :title

  scope :recent, -> { order(created_at: :desc) }

  scope :filter_by_title, lambda { |title|
    where("(LOWER(title) like '%#{title.gsub(/'/, "''").downcase}%')")
  }

  scope :filter_titles_not_exist, lambda { |titles|
    where('title NOT IN (?)', titles)
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

  scope :filter_with_region, lambda { |regions|
    joins(:career_regions).where('career_regions.region_id IN (?)', regions)
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

  def self.find_career(career_title)
    career = Career.find_by_title(career_title)

    unless career.present?
      raise "Do not found with career: '#{career_title}'.
        Please make sure import Career before."
    end

    career
  end

  # Remove all careers do not exists in TSV file import
  def self.remove_careers(csv_file)
    titles = csv_file.map { |row| row[0].strip }.uniq
    careers = Career.filter_titles_not_exist(titles)

    careers.delete_all if careers.present?
  end

  def self.import_from_csv(csv)
    Career.transaction do
      csv.each do |row|
        params = {
          title: row[0].strip
        }

        params[:salary_min] = row[7].strip
        params[:salary_max] = row[8].strip
        params[:about_job] = row[10].strip
        params[:what_will_do] = row[11].strip
        params[:demand] = row[14].strip
        params[:photo_large] = row[15].strip
        params[:photo_medium] = row[16].strip
        params[:projected_growth] = row[18].strip

        if Career.exists?(title: params[:title])
          career = Career.find_by_title(params[:title])

          career.update_attributes(params) if career.present?
        else
          career = Career.create(params)
        end

        # Adding interests
        create_career_interests(row[6].split(';').map(&:strip), career) if row[6].present?

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
        career = Career.find_career(row[0].strip)

        # Adding related_career_by_skill
        if row[12].present?
          create_career_skillships(row[12].split(';').map(&:strip), career)
        end

        # Adding related_career_by_interest
        if row[13].present?
          create_career_interestships(row[13].split(';').map(&:strip), career)
        end
      end

      # Remove all Career do not exits in tsv file
      Career.remove_careers(csv)
    end
  end

  def self.create_career_interests(interests, career)
    interests.each do |interest_name|
      interest = Interest.find_interest(interest_name)

      next if CareerInterest.exists?(career_id: career.id, interest_id: interest.id)

      CareerInterest.create(
        career_id: career.id,
        interest_id: interest.id
      )
    end
  end

  def self.create_career_skills(skills, career)
    skills.each do |skill_name|
      skill = Skill.find_skill(skill_name)

      next if CareerSkill.exists?(career_id: career.id, skill_id: skill.id)

      CareerSkill.create(
        career_id: career.id,
        skill_id: skill.id
      )
    end
  end

  def self.create_career_educations(educations, career)
    educations.each do |education_name|
      education = Education.find_education(education_name)

      next if CareerEducation.exists?(career_id: career.id, education_id: education.id)

      CareerEducation.create(
        career_id: career.id,
        education_id: education.id
      )
    end
  end

  def self.create_career_regions(regions, career)
    regions.each do |region_name|
      region = Region.find_region(region_name)

      next if CareerRegionHighDemand.exists?(career_id: career.id, region_id: region.id)

      CareerRegionHighDemand.create(
        career_id: career.id,
        region_id: region.id
      )
    end
  end

  def self.create_career_interestships(careers, career)
    careers.each do |career_name|
      career_related = Career.find_career(career_name)

      career_interestship = CareerInterestship.where(
        career_id: career.id,
        career_related_id: career_related.id
      ).first

      next if career_interestship.present?

      CareerInterestship.create(
        career_id: career.id,
        career_related_id: career_related.id
      )
    end
  end

  def self.create_career_skillships(careers, career)
    careers.each do |career_name|
      career_related = Career.find_career(career_name)

      career_skillship = CareerSkillship.where(
        career_id: career.id,
        career_related_id: career_related.id
      ).first

      next if career_skillship.present?

      CareerSkillship.create(
        career_id: career.id,
        career_related_id: career_related.id
      )
    end
  end

  def self.create_career_cluster(cluster_name, career)
    cluster = Cluster.find_or_create(cluster_name)

    return if CareerCluster.exists?(career_id: career.id, cluster_id: cluster.id)

    CareerCluster.create(
      career_id: career.id,
      cluster_id: cluster.id
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

  def delete_top_job
    TopJob.where(career_id: id).delete_all
  end
end
