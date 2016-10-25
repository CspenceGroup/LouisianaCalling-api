# == Schema Information
#
# Table name: skills
#
#  id             :integer          not null, primary key
#  name           :string
#  url            :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
class Skill < ActiveRecord::Base
  has_many :career_skills, dependent: :destroy
  has_many :careers, through: :career_skills

  has_many :profile_skills, dependent: :destroy
  has_many :profiles, through: :profile_skills

  validates :name, presence: true
  validates :url, presence: true

  validates_uniqueness_of :name

  def self.import_from_csv(csv)
    Skill.transaction do
      Skill.delete_all

      csv.each do |row|
        name_str = row[0].strip
        next if Skill.exists?(name: name_str)

        skill = Skill.new
        skill[:name] = name_str
        skill[:url] = row[1].strip

        skill.save!
      end
    end
  end

  def to_s
    name
  end
end
