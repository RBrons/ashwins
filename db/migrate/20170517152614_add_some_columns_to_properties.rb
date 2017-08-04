class AddSomeColumnsToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :zip, :string
    add_column :properties, :st_address_suffix, :string
  end
end
