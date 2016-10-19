class CreateCareerInterest < ActiveRecord::Migration[5.0]
  def change
    create_table :career_interests do |t|
      t.references :career
      t.references :interest
    end
  end
end
