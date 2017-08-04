class AddQiFundToTransactionMain < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_mains, :qi_funds, :decimal, precision: 15, scale: 2, :default => 0
  end
end
