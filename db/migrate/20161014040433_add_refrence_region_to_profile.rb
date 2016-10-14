class AddRefrenceRegionToProfile < ActiveRecord::Migration[5.0]
  def change
    add_reference :profiles, :region
    add_reference :profiles, :cluster
    remove_column :profiles, :region, :string
    remove_column :profiles, :interests, :text
    remove_column :profiles, :skills, :text
    remove_column :profiles, :education, :string
    remove_column :profiles, :cluster, :string
    add_column :profiles, :educational_institution, :string
  end
end
