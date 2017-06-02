class AddLeaseIsProRatedToProperty < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :lease_is_pro_rated, :boolean, :default => false
  end
end
