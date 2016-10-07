class AddProfileToVideos < ActiveRecord::Migration[5.0]
  def change
    remove_column :videos, :title, :string
    remove_column :videos, :main_title, :string
    remove_column :videos, :url, :string
    add_column :videos, :profile_name, :string
  end
end
