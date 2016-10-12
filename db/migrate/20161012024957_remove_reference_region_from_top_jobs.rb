class RemoveReferenceRegionFromTopJobs < ActiveRecord::Migration[5.0]
  def change
    remove_reference :top_jobs, :region, foreign_key: true
  end
end
