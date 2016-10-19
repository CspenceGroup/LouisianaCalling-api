class CreateProgramCareer < ActiveRecord::Migration[5.0]
  def change
    create_table :program_careers do |t|
      t.references :career, index: true
      t.references :program, index: true
    end
  end
end
