class RemoveRegionStringFromProgram < ActiveRecord::Migration[5.0]
  def change
    remove_column :programs, :region, :string
    remove_column :programs, :education, :string
    remove_column :programs, :industries, :text
    remove_column :programs, :interests, :string
    remove_column :programs, :career, :string
    add_reference :programs, :region
    add_reference :programs, :education
  end
end
