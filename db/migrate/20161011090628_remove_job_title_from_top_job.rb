class RemoveJobTitleFromTopJob < ActiveRecord::Migration[5.0]
  def change
    remove_column :top_jobs, :job_title, :string
  end
end
