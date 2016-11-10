class AddHomeUrlToInterest < ActiveRecord::Migration[5.0]
  def change
    add_column :interests, :home_url, :string
    add_column :interests, :gj_url, :string
    add_column :interests, :gj_url_selected, :string
    remove_column :interests, :url_selected, :string
  end
end
