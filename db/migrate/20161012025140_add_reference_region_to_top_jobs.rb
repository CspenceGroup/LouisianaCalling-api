class AddReferenceRegionToTopJobs < ActiveRecord::Migration[5.0]
  def change
    add_reference :top_jobs, :region, foreign_key: false
  end
end
