class AddDemandToCareerRegion < ActiveRecord::Migration[5.0]
  def change
    add_column :career_regions, :demand, :integer
  end
end
