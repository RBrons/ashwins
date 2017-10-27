class AddRentIncreaseInBaseTermStatusToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :rent_increase_in_base_term_status, :boolean, default: false
  end
end
