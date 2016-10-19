class AddSubHeadToProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :sub_head, :string
  end
end
