class RemoveIconFromCareer < ActiveRecord::Migration[5.0]
  def change
    remove_column :careers, :icon, :string
  end
end
