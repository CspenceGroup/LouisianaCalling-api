class CreateProfileCareer < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_careers do |t|
      t.references :profile
      t.references :career
    end
  end
end
