class AddCoverPhotoToEducation < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :cover_photo, :string
  end
end
