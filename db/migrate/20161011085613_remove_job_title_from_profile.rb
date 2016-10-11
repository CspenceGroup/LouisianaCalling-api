class RemoveJobTitleFromProfile < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :job_title, :string
  end
end
