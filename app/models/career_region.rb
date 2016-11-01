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
      # CareerRegion.delete_all
      # CareerRegionEducation.delete_all

      csv.each do |row|
        career = Career.find_career(row[0].strip)
        region = Region.find_region(row[1].strip)

        params = {
          salary_min: row[2].strip,
          salary_max: row[3].strip,
          demand: row[5].strip
        }

        params[:career_id] = career.id if career.present?
        params[:region_id] = region.id if region.present?

        career_region = CareerRegion.where(
          career_id: career.id,
          region_id: region.id
        ).first

        if career_region.present?
          career_region.update_attributes(params)
        else
          career_region = CareerRegion.create(params)
        end

        if row[4].present?
          create_career_region_educations(row[4].split(',').map(&:strip), career_region)
        end
      end
    end
  end

  def self.create_career_region_educations(educations, career_region)
    educations.each do |education_name|
      education = Education.find_education(education_name)

      next if CareerRegionEducation.exists?(
        career_region_id: career_region.id,
        education_id: education.id
      )

      CareerRegionEducation.create(
        career_region_id: career_region.id,
        education_id: education.id
      )
    end
  end
end
