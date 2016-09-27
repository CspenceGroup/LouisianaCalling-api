class AddSlugToPrograms < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :slug, :string
  end
end
