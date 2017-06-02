class AddLeaseSlabInYearsToProperty < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :lease_slab_in_years, :integer
  end
end
