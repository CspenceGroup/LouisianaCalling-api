class AddCareerToPrograms < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :career, :string
  end
end
