class RemoveRegionFromCareers < ActiveRecord::Migration[5.0]
  def change
    remove_column :careers, :regions_high_demand, :string
    remove_column :careers, :education, :string
    remove_column :careers, :related_career_by_skill, :string
    remove_column :careers, :related_career_by_interest, :string
    remove_column :careers, :profile_name, :string
    remove_column :careers, :photo_small, :string
    remove_column :careers, :industries, :string
    remove_column :careers, :interests, :string
    remove_column :careers, :skills, :string
  end
end
