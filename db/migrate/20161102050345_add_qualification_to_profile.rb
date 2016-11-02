class AddQualificationToProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :qualification, :string
  end
end
