class AddRefrenceCareerToCareerRegion < ActiveRecord::Migration[5.0]
  def change
    add_reference :career_regions, :career, index: true
    add_reference :career_regions, :region, index: true
  end
end
