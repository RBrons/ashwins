class RemoveTenantIsFromProperties < ActiveRecord::Migration[5.0]
  def change
    remove_column :properties, :tenant_is, :string
  end
end
