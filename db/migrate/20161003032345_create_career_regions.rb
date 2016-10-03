class CreateCareerRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :career_regions do |t|
      t.string :title
      t.string :region
      t.integer :salary_min
      t.integer :salary_max
      t.string :education

      t.timestamps
    end
  end
end
