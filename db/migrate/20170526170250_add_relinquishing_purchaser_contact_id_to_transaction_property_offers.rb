class AddRelinquishingPurchaserContactIdToTransactionPropertyOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_property_offers, :relinquishing_purchaser_contact_id, :integer
  end
end
