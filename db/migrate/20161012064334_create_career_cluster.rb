class CreateCareerCluster < ActiveRecord::Migration[5.0]
  def change
    create_table :career_clusters do |t|
      t.references :career
      t.references :cluster
    end
  end
end
