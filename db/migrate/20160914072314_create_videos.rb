class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.string :main_title
      t.string :description

      t.timestamps
    end
  end
end
