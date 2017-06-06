class AddDescriptionToRentTable < ActiveRecord::Migration[5.0]
  def change
    add_column :rent_tables, :description, :string
  end
end
