class CreateCareerSkill < ActiveRecord::Migration[5.0]
  def change
    create_table :career_skills do |t|
      t.references :career
      t.references :skill
    end
  end
end
