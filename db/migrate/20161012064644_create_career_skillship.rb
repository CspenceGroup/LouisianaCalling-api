class CreateCareerSkillship < ActiveRecord::Migration[5.0]
  def change
    create_table :career_skillships do |t|
      t.references :career, index: true
      t.references :career_related, index: true
    end
  end
end
