class AddCompositeIndexToTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    add_index :transaction_properties , [:property_id , :transaction_id] , :unique => true
  end
end
