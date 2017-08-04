class AddTransactionMainIdToTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_properties, :transaction_main_id, :integer
  end
end
