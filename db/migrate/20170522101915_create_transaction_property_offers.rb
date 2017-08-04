class CreateTransactionPropertyOffers < ActiveRecord::Migration[5.0]
  def change
    drop_table 'property_offers' if ActiveRecord::Base.connection.table_exists? 'property_offers'

    create_table :transaction_property_offers do |t|
      t.string :offer_name
      t.integer :transaction_property_id
      t.boolean :is_accepted
      t.integer :accepted_counteroffer_id

      t.timestamps
    end
  end
end
