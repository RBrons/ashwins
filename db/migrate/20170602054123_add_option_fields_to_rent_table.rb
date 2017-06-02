class AddOptionFieldsToRentTable < ActiveRecord::Migration[5.0]
  def change
    add_column :rent_tables, :is_option, :boolean, :default => false
    add_column :rent_tables, :option_slab, :integer
  end
end
