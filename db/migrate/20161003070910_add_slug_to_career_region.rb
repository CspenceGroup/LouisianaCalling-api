class AddSlugToCareerRegion < ActiveRecord::Migration[5.0]
  def change
    add_column :career_regions, :slug, :string
  end
end
