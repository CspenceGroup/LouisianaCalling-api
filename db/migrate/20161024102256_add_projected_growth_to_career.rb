class AddProjectedGrowthToCareer < ActiveRecord::Migration[5.0]
  def change
    add_column :careers, :projected_growth, :integer
  end
end
