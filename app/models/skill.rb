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

  scope :filter_names_not_exist, lambda { |names|
    where('name NOT IN (?)', names)
  }

  def self.update_skill(params)
    skill = Skill.find_by_name(params[:name])

    raise "Do not found with skill: '#{params[:name]}'." unless skill.present?

    skill.update_attributes(params)
  end

  def self.find_skill(skill_name)
    skill = Skill.find_by_name(skill_name)
    unless skill.present?
      raise "Do not found with skill: '#{skill_name}'.
        Please make sure import Skill before."
    end

    skill
  end

  # Remove all skills do not exists in TSV file import
  def self.remove(names)
    skills = Skill.filter_names_not_exist(names)

    skills.delete_all if skills.present?
  end

  def self.import_from_csv(csv)
    Skill.transaction do
      # Skill.delete_all

      csv.each do |row|
        params = {
          name: row[0].strip,
          url: row[1].strip
        }

        if Skill.exists?(name: params[:name])
          Skill.update_skill(params)
        else
          Skill.create(params)
        end
      end

      # Remove all Skill do not exists in tsv file
      names = csv.map { |row| row[0].strip }.uniq
      Skill.remove(names)
    end
  end

  def to_s
    name
  end
end
