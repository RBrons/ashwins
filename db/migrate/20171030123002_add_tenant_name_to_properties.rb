class AddTenantNameToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :tenant_name, :string
  end
end
