class AddRentCommencementDependOnExpirationToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :rent_commencement_depend_on_expiration, :boolean, default: false
  end
end
