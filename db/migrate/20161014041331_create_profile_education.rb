class CreateProfileEducation < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_educations do |t|
      t.references :profile
      t.references :education
    end
  end
end
