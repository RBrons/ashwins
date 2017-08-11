class AddBrokerIdAndAttorneyIdToTransactionProperites < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_properties, :broker_id, :integer
    add_column :transaction_properties, :attorney_id, :integer
  end
end
