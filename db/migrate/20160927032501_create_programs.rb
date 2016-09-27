class CreatePrograms < ActiveRecord::Migration[5.0]
  def change
    create_table :programs do |t|
      t.string :title
      t.string :region
      t.text :traning_detail
      t.text :description
      t.string :duration
      t.string :time_of_day
      t.string :hours_per_weeks
      t.integer :tuition_min
      t.integer :tuition_max
      t.string :financial_help
      t.string :education
      t.string :institution_name
      t.string :phone
      t.string :address
      t.string :lat
      t.string :lng
      t.text :industries

      t.timestamps
    end
  end
end
