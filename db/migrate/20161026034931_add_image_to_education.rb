class AddImageToEducation < ActiveRecord::Migration[5.0]
  def change
    add_column :educations, :url, :string
    add_column :educations, :url_selected, :string
  end
end
