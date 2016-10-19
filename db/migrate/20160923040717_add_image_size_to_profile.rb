class AddImageSizeToProfile < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :image, :string
    add_column :profiles, :image_large, :string
    add_column :profiles, :image_medium, :string
    add_column :profiles, :image_small, :string
  end
end
