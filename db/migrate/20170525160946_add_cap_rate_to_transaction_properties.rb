class AddCapRateToTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_properties, :cap_rate, :decimal
  end
end
