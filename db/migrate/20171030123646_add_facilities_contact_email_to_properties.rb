class AddFacilitiesContactEmailToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :facilities_contact_email, :string
  end
end
