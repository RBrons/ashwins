class AddIsSelectedToTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_properties, :is_selected, :boolean, default: false
  end
end
