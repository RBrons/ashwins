class AddLeaseColumnsToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :lease_base_rent, :decimal, precision: 15, scale: 2
    add_column :properties, :lease_duration_in_years, :integer
    add_column :properties, :lease_rent_increase_type, :string
    add_column :properties, :lease_rent_increase_percentage, :decimal, precision: 5, scale: 2
    add_column :properties, :lease_rent_slab_in_years, :integer
  end
end
