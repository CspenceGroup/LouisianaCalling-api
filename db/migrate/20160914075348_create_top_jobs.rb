class CreateTopJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :top_jobs do |t|
      t.string :region
      t.string :job_title

      t.timestamps
    end
  end
end
