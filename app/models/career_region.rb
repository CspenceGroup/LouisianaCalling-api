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

      csv.each do |row|
        raise 'Wrong file' if row[6].present?

        career_region = CareerRegion.new

        career = Career.find_by_title(row[0].strip)
        next unless career.present?
        career_region[:career_id] = career.id

        region = Region.find_by_name(row[1].strip)
        next unless region.present?
        career_region[:region_id] = region.id

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
      education = Education.find_by_name(education_name)

      # Adding new education
      unless education.present?
        education = Education.create(name: education_name)
      end

      CareerRegionEducation.create(
        career_region_id: career_region.id,
        education_id: education.id
      )
    end
  end
end
