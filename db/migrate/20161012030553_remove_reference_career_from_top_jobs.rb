class RemoveReferenceCareerFromTopJobs < ActiveRecord::Migration[5.0]
  def change
    remove_reference :top_jobs, :career, foreign_key: true
    add_reference :top_jobs, :career, foreign_key: false
  end
end
