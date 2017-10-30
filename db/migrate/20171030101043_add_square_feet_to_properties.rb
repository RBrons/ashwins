class AddSquareFeetToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :square_feet, :decimal
  end
end
