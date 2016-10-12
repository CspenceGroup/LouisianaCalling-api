class RemoveProfileNameFromVideos < ActiveRecord::Migration[5.0]
  def change
    remove_column :videos, :profile_name, :string
    add_reference :videos, :profile, index: true, foreign_key: true
  end
end
