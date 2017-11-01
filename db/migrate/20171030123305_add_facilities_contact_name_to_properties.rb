class AddFacilitiesContactNameToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :facilities_contact_name, :string
  end
end
