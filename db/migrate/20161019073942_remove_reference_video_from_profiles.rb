class RemoveReferenceVideoFromProfiles < ActiveRecord::Migration[5.0]
  def change
    remove_reference :profiles, :video
  end
end
