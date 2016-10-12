class AddReferenceToJobToCareers < ActiveRecord::Migration[5.0]
  def change
    add_reference :careers, :top_job, index: true
  end
end
