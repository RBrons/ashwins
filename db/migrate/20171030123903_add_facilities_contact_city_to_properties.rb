class AddFacilitiesContactCityToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :facilities_contact_city, :string
  end
end
