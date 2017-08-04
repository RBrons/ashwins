class AddVersionToRentTables < ActiveRecord::Migration[5.0]
  def change
    add_column :rent_tables, :version, :integer
  end
end
