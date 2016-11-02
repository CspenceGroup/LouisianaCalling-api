class DropProfileEducation < ActiveRecord::Migration[5.0]
  def change
    drop_table :profile_educations
  end
end
