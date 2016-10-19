class AddReferenceVideoToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_reference :profiles, :video, index: true
  end
end
