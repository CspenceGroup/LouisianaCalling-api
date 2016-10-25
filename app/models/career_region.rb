# == Schema Information
#
# Table name: career_regions
#
#  id            :integer          not null, primary key
#  region_id     :integer
#  career_id     :integer
#  salary_min    :integer
#  salary_max    :integer
#  demand        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
#
class CareerRegion < ActiveRecord::Base
  belongs_to :region
  belongs_to :career

  has_many :career_region_educations, dependent: :destroy
  has_many :educations, through: :career_region_educations, source: :education

  validates_presence_of :region, :career

  def self.import_from_csv(csv)
    CareerRegion.transaction do
      CareerRegion.delete_all
      CareerRegionEducation.delete_all

      csv.each do |row|
        career_region = CareerRegion.new

        career = Career.find_by_title(row[0].strip)
        raise "Do not found with career: '#{row[0].strip}'. Please make sure import Career before." unless career.present?
        career_region[:career_id] = career.id if career.present?

        region = Region.find_region(row[1].strip)
        career_region[:region_id] = region.id if region.present?

        career_region[:salary_min] = row[2].strip
        career_region[:salary_max] = row[3].strip
        career_region[:demand] = row[5].strip

        career_region.save!
        if row[4].present?
          create_career_region_educations(row[4].split(',').map(&:strip), career_region)
        end
      end
    end
  end

  def self.create_career_region_educations(educations, career_region)
    educations.each do |education_name|
      education = Education.find_or_create(education_name)

      CareerRegionEducation.create(
        career_region_id: career_region.id,
        education_id: education.id
      )
    end
  end
end
