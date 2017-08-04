class AddRentTableVersionToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :rent_table_version, :integer
  end
end
