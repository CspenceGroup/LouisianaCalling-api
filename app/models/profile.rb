class Profile < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_by_name, use: :slugged

  belongs_to :cluster
  belongs_to :region

  has_many :profile_careers, dependent: :destroy
  has_many :careers, through: :profile_careers, source: :career

  has_many :profile_interests, dependent: :destroy
  has_many :interests, through: :profile_interests, source: :interest

  has_many :profile_skills, dependent: :destroy
  has_many :skills, through: :profile_skills, source: :skill

  # has_many :profile_educations, dependent: :destroy
  # has_many :educations, through: :profile_educations, source: :education

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

  before_destroy :delete_relationships

  scope :find_by_full_name, lambda { |full_name|
    where('concat_ws(\' \', first_name, last_name) = ?', full_name)
  }

  scope :filter_profiles_not_exist, lambda { |names|
    where('concat_ws(\' \', first_name, last_name) NOT IN (?)', names)
  }

  # Remove all profiles do not exists in TSV file import
  def self.remove_profiles(csv_file)
    names = csv_file.map { |row| "#{row[0].strip} #{row[1].strip}" }.uniq
    profiles = Profile.filter_profiles_not_exist(names)

    profiles.delete_all if profiles.present?
  end

  def self.import_from_csv(csv)
    Profile.transaction do
      csv.each do |row|
        region = Region.find_region(row[4].strip)
        cluster = Cluster.find_or_create(row[9].strip)

        params = {
          first_name: row[0].strip,
          last_name: row[1].strip,
          sub_head: row[2].strip,
          educational_institution: row[3].strip,
          description: row[5].strip,
          demand: row[8].strip,
          salary: row[10].strip,
          qualification: row[11].strip,
          video: row[12].strip,
          image_medium: row[13].strip,
          image_small: row[14].strip,
          image_large: row[15].strip
        }

        params[:region_id] = region.id if region.present?
        params[:cluster_id] = cluster.id if cluster.present?

        full_name = "#{params[:first_name]} #{params[:last_name]}"

        profile = Profile.find_by_full_name(full_name)
                         .first

        if profile.present?
          profile.update_attributes(params)
          profile.delete_relationships
        else
          profile = Profile.create(params)
        end

        # Adding careers
        if row[16].present?
          create_profile_careers(row[16].split(',').map(&:strip), profile)
        end

        # Adding interest
        if row[6].present?
          create_profile_interests(row[6].split(';').map(&:strip), profile)
        end

        # Adding skills
        if row[7].present?
          create_profile_skills(row[7].split(',').map(&:strip), profile)
        end
      end
      # Remove all profile do not exists in TSV file
      Profile.remove_profiles(csv)
    end
  end

  def self.create_profile_careers(careers, profile)
    careers.each do |career_name|
      career = Career.find_career(career_name)

      next if ProfileCareer.exists?(
        profile_id: profile.id,
        career_id: career.id
      )

      ProfileCareer.create(
        profile_id: profile.id,
        career_id: career.id
      )
    end
  end

  def self.create_profile_interests(interests, profile)
    interests.each do |interest_name|
      interest = Interest.find_interest(interest_name)

      next if ProfileInterest.exists?(
        profile_id: profile.id,
        interest_id: interest.id
      )

      ProfileInterest.create(
        profile_id: profile.id,
        interest_id: interest.id
      )
    end
  end

  def self.create_profile_skills(skills, profile)
    skills.each do |skill_name|
      skill = Skill.find_skill(skill_name)

      next if ProfileSkill.exists?(profile_id: profile.id, skill_id: skill.id)

      ProfileSkill.create(
        profile_id: profile.id,
        skill_id: skill.id
      )
    end
  end

  def delete_relationships
    ProfileCareer.where(profile_id: id).delete_all
    ProfileInterest.where(profile_id: id).delete_all
    ProfileSkill.where(profile_id: id).delete_all
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
