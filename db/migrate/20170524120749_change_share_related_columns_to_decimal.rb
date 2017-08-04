class ChangeShareRelatedColumnsToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :entities, :number_of_assets, :decimal
  end
end
