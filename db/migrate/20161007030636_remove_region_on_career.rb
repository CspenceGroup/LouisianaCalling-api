class RemoveRegionOnCareer < ActiveRecord::Migration[5.0]
  def change
    remove_column :careers, :region, :string
  end
end
