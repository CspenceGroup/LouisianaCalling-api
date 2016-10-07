class Profile < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_by_name, use: :slugged

  serialize :interests, Array
  serialize :skills, Array

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :job_title, presence: true
  validates :region, presence: true
  validates :description, presence: true
  validates :interests, presence: true
  validates :skills, presence: true
  validates :demand, presence: true
  validates :cluster, presence: true
  validates :salary, presence: true
  validates :education, presence: true
  validates :video, presence: true
  validates :image_large, presence: true
  validates :image_medium, presence: true
  validates :image_small, presence: true

  scope :find_by_full_name, lambda { |full_name|
    full_name = full_name.split(' ')
    where('first_name = ? AND last_name = ?', full_name.first, full_name.last)
  }

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

  def self.import_from_csv(csv)
    Profile.transaction do
      Profile.delete_all

      csv.each do |row|
        profile = Profile.new
        profile[:first_name] = row[0].strip
        profile[:last_name] = row[1].strip
        profile[:job_title] = row[2].strip
        # profile[:education] = row[3]
        profile[:region] = row[4].strip
        profile[:description] = row[5].strip

        if row[6]
          profile[:interests] = row[6].split(',').map{ |s| s.strip }
        end

        if row[7]
          profile[:skills] = row[7].split(',').map{ |s| s.strip }
        end

        profile[:demand] = row[8].strip
        profile[:cluster] = row[9].strip
        profile[:salary] = row[10].strip
        profile[:education] = row[11].strip
        profile[:video] = row[12].strip
        profile[:image_medium] = row[13].strip
        profile[:image_small] = row[14].strip
        profile[:image_large] = row[15].strip

        if row[16]
          raise "Wrong file"
        end

        profile.save!
      end
    end
  end
end
