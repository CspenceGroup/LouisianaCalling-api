class CreateProgramCluster < ActiveRecord::Migration[5.0]
  def change
    create_table :program_clusters do |t|
      t.references :cluster, foreign_key: true
      t.references :program, foreign_key: true
    end
  end
end
