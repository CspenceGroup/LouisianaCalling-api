class Profile < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_by_name, use: :slugged

  belongs_to :cluster
  belongs_to :region

  has_many :profile_careers, dependent: :destroy
  has_many :careers, through: :profile_careers, source: :career

  has_one :video

  has_many :profile_interests, dependent: :destroy
  has_many :interests, through: :profile_interests, source: :interest

  has_many :profile_skills, dependent: :destroy
  has_many :skills, through: :profile_skills, source: :skill

  has_many :profile_educations, dependent: :destroy
  has_many :educations, through: :profile_educations, source: :education

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :region, presence: true
  validates :description, presence: true
  # validates :interests, presence: true
  # validates :skills, presence: true
  validates :demand, presence: true
  validates :cluster, presence: true
  validates :salary, presence: true
  validates :video, presence: true
  validates :image_large, presence: true
  validates :image_medium, presence: true
  validates :image_small, presence: true

  scope :find_by_full_name, lambda { |full_name|
    full_name = full_name.split(' ')
    where('first_name = ? AND last_name = ?', full_name.first, full_name.last)
  }

  def self.import_from_csv(csv)
    Profile.transaction do
      Profile.delete_all

      csv.each do |row|
        raise 'Wrong file' if row[16].present?

        profile = Profile.new
        profile[:first_name] = row[0].strip
        profile[:last_name] = row[1].strip

        region = Region.find_by_name(row[4].strip)
        profile[:region_id] = region.id if region.present?

        profile[:educational_institution] = row[3].strip
        profile[:description] = row[5].strip
        profile[:demand] = row[8].strip

        cluster = Cluster.find_by_name(row[9].strip)
        profile[:cluster_id] = cluster.id if cluster.present?

        profile[:salary] = row[10].strip

        profile[:video] = row[12].strip
        profile[:image_medium] = row[13].strip
        profile[:image_small] = row[14].strip
        profile[:image_large] = row[15].strip

        profile.save!

        # Adding careers
        create_profile_careers(row[2].split(',').map(&:strip), profile) if row[2].present?

        # Adding interest
        if row[6].present?
          create_profile_interests(row[6].split(',').map(&:strip), profile)
        end

        # Adding skills
        if row[7].present?
          create_profile_skills(row[7].split(',').map(&:strip), profile)
        end

        # Adding Education need
        if row[11].present?
          create_profile_educations(row[11].split(',').map(&:strip), profile)
        end
      end
    end
  end

  def self.create_profile_careers(careers, profile)
    careers.each do |career_name|
      career = Career.find_by_title(career_name)

      ProfileCareer.create(
        profile_id: profile.id,
        career_id: career.present? ? career.id : nil
      )
    end
  end

  def self.create_profile_interests(interests, profile)
    interests.each do |interest_name|
      interest = Interest.find_by_name(interest_name)

      ProfileInterest.create(
        profile_id: profile.id,
        interest_id: interest.present? ? interest.id : nil
      )
    end
  end

  def self.create_profile_skills(skills, profile)
    skills.each do |skill_name|
      skill = Skill.find_by_name(skill_name)

      ProfileSkill.create(
        profile_id: profile.id,
        skill_id: skill.present? ? skill.id : nil
      )
    end
  end

  def self.create_profile_educations(educations, profile)
    educations.each do |education_name|
      education = Education.find_by_name(education_name)

      ProfileEducation.create(
        profile_id: profile.id,
        education_id: education.present? ? education.id : nil
      )
    end
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  private

  def full_name
    "#{first_name} #{last_name}"
  end

  # Defaults a slug with name
  def slug_by_name
    "#{full_name.gsub(/[^a-zA-Z0-9]/, '-')}-#{id}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || first_name_changed? || last_name_changed?
  end
end
