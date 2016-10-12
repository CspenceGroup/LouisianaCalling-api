class AddReferenceToJobToRegions < ActiveRecord::Migration[5.0]
  def change
    add_reference :regions, :top_job, index: true
  end
end
