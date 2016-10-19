class CreateCareerRegionHighDemand < ActiveRecord::Migration[5.0]
  def change
    create_table :career_region_high_demands do |t|
      t.references :career, index: true
      t.references :region, index: true
    end
  end
end
