class CreateCareers < ActiveRecord::Migration[5.0]
  def change
    create_table :careers do |t|
      t.string :slug
      t.string :title
      t.string :region
      t.string :salary
      t.string :education
      t.text :about_job
      t.text :what_will_do
      t.string :related_career_by_skill
      t.string :related_career_by_interest
      t.string :profile_name
      t.text :job_growth


      t.timestamps
    end
  end
end
