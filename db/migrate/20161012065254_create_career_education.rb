class CreateCareerEducation < ActiveRecord::Migration[5.0]
  def change
    create_table :career_educations do |t|
      t.references :career, index: true
      t.references :education, index: true
    end
  end
end
