class RemoveRegionFromTopJob < ActiveRecord::Migration[5.0]
  def change
    remove_column :top_jobs, :region, :string
    add_reference :top_jobs, :career
    add_reference :top_jobs, :region
  end
end
