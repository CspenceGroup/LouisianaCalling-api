class RemoveIconFromEducation < ActiveRecord::Migration[5.0]
  def change
    remove_column :educations, :url, :string
    remove_column :educations, :url_selected, :string
  end
end
