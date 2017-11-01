class AddFacilitiesContactCountryToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :facilities_contact_country, :string
  end
end
