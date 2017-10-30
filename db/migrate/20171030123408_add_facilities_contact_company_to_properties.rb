class AddFacilitiesContactCompanyToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :facilities_contact_company, :string
  end
end
