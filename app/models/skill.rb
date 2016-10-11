class Skill < ActiveRecord::Base

  has_many :career_skills, dependent: :destroy
  has_many :careers, through: :career_skills

  has_many :profile_skills, dependent: :destroy
  has_many :profiles, through: :profile_skills

  validates :name, presence: true
  validates :url, presence: true

  def self.import_from_csv(csv)
    Skill.transaction do
      Skill.delete_all

      csv.each do |row|
        skill = Skill.new
        skill[:name] = row[0].strip
        skill[:url] = row[1].strip

        if row[2]
          raise "Wrong file"
        end

        skill.save!
      end
    end
  end
end
