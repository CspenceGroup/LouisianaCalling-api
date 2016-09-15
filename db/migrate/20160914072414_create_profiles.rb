class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :job_title
      t.string :region
      t.string :facebook
      t.string :twitter
      t.string :email
      t.text :description
      t.text :interests
      t.text :skills
      t.string :demand
      t.string :cluster
      t.string :salary
      t.string :education
      t.string :video
      t.string :image

      t.timestamps
    end
  end
end
