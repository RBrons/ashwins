class AddOptionalExtensionsStatusToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :optional_extensions_status, :boolean, default: true
  end
end
