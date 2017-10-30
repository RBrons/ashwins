class AddFacilitiesContactPhoneToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :facilities_contact_phone, :string
  end
end
