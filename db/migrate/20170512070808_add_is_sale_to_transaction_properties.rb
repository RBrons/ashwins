class AddIsSaleToTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_properties, :is_sale, :boolean
  end
end
