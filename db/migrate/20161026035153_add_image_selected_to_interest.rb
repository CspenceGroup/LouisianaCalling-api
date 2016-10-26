class AddImageSelectedToInterest < ActiveRecord::Migration[5.0]
  def change
    add_column :interests, :url_selected, :string
  end
end
