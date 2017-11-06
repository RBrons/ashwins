class AddBrokerContactIdAndAttorneyContactIdToTransactionPropertyOffers < ActiveRecord::Migration[5.0]
  def change
    rename_column :transaction_property_offers, :relinquishing_purchaser_contact_id, :client_contact_id
    add_column    :transaction_property_offers, :broker_contact_id, :integer
    add_column    :transaction_property_offers, :attorney_contact_id, :integer
  end
end
