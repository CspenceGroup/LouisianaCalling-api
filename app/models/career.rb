class Career < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_by_title, use: :slugged

  has_many :regions_high_demand, class_name: 'Region'

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

  belongs_to :education

  # serialize :regions_high_demand, Array
  # serialize :interests, Array
  # serialize :skills, Array
  # serialize :industries, Array
  # serialize :related_career_by_skill, Array
  # serialize :related_career_by_interest, Array
  # serialize :region, Array

  validates :title, presence: true
  validates :education, presence: true
  validates :about_job, presence: true
  validates :what_will_do, presence: true
  # validates :profile_name, presence: true
  validates :photo_large, presence: true
  validates :photo_medium, presence: true
  # validates :photo_small, presence: true
  validates :industries, presence: true
  validates :interests, presence: true
  validates :skills, presence: true
  validates :salary_min, presence: true
  validates :salary_max, presence: true
  validates :demand, presence: true
  validates :regions_high_demand, presence: true

  scope :filter_by_title, lambda { |titles|
    where('title IN (?)', titles)
  }

  scope :filter_by_title_and_region, lambda { |title, region|
    where('LOWER(title) like ? AND regions_high_demand like ?', title.downcase, region)
  }

  scope :filter_by_salary, lambda { |salary_min, salary_max|
    where('salary_max <= ? AND salary_min >= ?', salary_max, salary_min)
  }

  private

  # Defaults a slug with title
  def slug_by_title
    "#{title.gsub(/[^a-zA-Z0-9]/, '-')}-#{id}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def self.import_from_csv(csv)
    Career.transaction do
      Career.delete_all

      csv.each do |row|
        career = Career.new
        career[:title] = row[0].strip
        # career[:slug] = row[0].parameterize
        career[:industries] = []

        (1..4).each do |i|
          career[:industries] << row[i].strip if row[i].present?
        end

        career[:skills] = row[5].split(',').map(&:strip)
        career[:interests] = row[6].split(',').map(&:strip)
        career[:salary_min] = row[7].strip
        career[:salary_max] = row[8].strip
        career[:education] = row[9].strip
        career[:about_job] = row[10].strip
        career[:what_will_do] = row[11].strip
        career[:related_career_by_skill] = row[12].split(';').map(&:strip) if row[12]
        career[:related_career_by_interest] = row[13].split(';').map(&:strip) if row[13]
        career[:demand] = row[14].strip
        career[:photo_large] = row[15].strip if row[15]
        career[:photo_medium] = row[16].strip if row[16]
        career[:regions_high_demand] = row[17].split(',').map(&:strip)
        career[:profile_name] = row[18].strip if row[18]

        raise 'Wrong file' if row[19]

        career.save!
      end
    end
  end
end
