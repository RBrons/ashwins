class ChangeSquareFeetTypeToInteger < ActiveRecord::Migration[5.0]
  def up
    change_column :properties, :square_feet, :integer
  end
end
