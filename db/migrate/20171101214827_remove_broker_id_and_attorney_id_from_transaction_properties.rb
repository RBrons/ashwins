class RemoveBrokerIdAndAttorneyIdFromTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    remove_column :transaction_properties, :broker_id, :integer
    remove_column :transaction_properties, :attorney_id, :integer
  end
end
