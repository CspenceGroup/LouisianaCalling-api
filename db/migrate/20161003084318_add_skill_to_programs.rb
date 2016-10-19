class AddSkillToPrograms < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :interests, :string
  end
end
