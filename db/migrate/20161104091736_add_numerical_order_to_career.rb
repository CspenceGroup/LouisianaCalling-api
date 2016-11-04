class AddNumericalOrderToCareer < ActiveRecord::Migration[5.0]
  def change
    add_column :careers, :numerical_order, :integer
  end
end
