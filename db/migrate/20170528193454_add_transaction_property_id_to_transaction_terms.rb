class AddTransactionPropertyIdToTransactionTerms < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_terms, :transaction_property_id, :integer, :unique => true 
  end
end
