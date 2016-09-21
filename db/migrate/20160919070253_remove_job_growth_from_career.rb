class RemoveJobGrowthFromCareer < ActiveRecord::Migration[5.0]
  def change
    remove_column :careers, :job_growth, :text
    remove_column :careers, :salary, :string
    add_column :careers, :photo_large, :string
    add_column :careers, :photo_medium, :string
    add_column :careers, :photo_small, :string
    add_column :careers, :industries, :text
    add_column :careers, :interests, :text
    add_column :careers, :skills, :text
    add_column :careers, :salary_min, :float
    add_column :careers, :salary_max, :float
    add_column :careers, :demand, :float
    add_column :careers, :regions_high_demand, :text
    add_column :careers, :icon, :string
  end
end
