class RemoveFinancialHelpToProgram < ActiveRecord::Migration[5.0]
  def change
    remove_column :programs, :financial_help, :string
  end
end
