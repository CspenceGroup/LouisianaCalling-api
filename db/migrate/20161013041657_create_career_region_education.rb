class CreateCareerRegionEducation < ActiveRecord::Migration[5.0]
  def change
    create_table :career_region_educations do |t|
      t.references :career_region, index: true
      t.references :education, index: true
    end
  end
end
