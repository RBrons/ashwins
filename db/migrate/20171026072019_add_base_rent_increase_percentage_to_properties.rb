class AddBaseRentIncreasePercentageToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :base_rent_increase_percentage, :decimal, precision: 5, scale: 2
  end
end
