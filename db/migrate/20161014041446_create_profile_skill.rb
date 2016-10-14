class CreateProfileSkill < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_skills do |t|
      t.references :profile
      t.references :skill
    end
  end
end
