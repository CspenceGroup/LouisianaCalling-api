class RemoveSlugFromCareerRegion < ActiveRecord::Migration[5.0]
  def change
    remove_column :career_regions, :slug, :string
    remove_column :career_regions, :title, :string
    remove_column :career_regions, :education, :string
    remove_column :career_regions, :region, :string
  end
end
