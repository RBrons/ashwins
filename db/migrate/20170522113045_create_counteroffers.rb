class CreateCounteroffers < ActiveRecord::Migration[5.0]
  def change
    drop_table 'counteroffers' if ActiveRecord::Base.connection.table_exists? 'counteroffers'

    create_table :counteroffers do |t|
      t.integer :transaction_property_offer_id
      t.date  :offered_date
      t.string :offer_type
      t.decimal :offered_price, precision: 15, scale: 2

      t.timestamps
    end
  end
end
