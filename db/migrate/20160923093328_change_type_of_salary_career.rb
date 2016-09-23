class ChangeTypeOfSalaryCareer < ActiveRecord::Migration[5.0]
  def change
    change_column :careers, :salary_min,  :integer
    change_column :careers, :salary_max,  :integer
  end
end
