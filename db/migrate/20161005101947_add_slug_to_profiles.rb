class AddSlugToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :slug, :string
  end
end
