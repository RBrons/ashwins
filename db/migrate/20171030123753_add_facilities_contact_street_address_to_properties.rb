class AddFacilitiesContactStreetAddressToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :facilities_contact_street_address, :string
  end
end
