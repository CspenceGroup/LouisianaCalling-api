class CreateProgramCluster < ActiveRecord::Migration[5.0]
  def change
    create_table :program_clusters do |t|
      t.references :cluster, index: true
      t.references :program, index: true
    end
  end
end
