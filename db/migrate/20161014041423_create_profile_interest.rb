class CreateProfileInterest < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_interests do |t|
      t.references :profile
      t.references :interest
    end
  end
end
