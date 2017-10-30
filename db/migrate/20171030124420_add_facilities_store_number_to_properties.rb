class AddFacilitiesStoreNumberToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :facilities_store_number, :string
  end
end
