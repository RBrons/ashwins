class AddTenantIdToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :tenant_id, :integer
  end
end
