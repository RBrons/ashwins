class CreateTransactionBasketProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :transaction_basket_properties do |t|
      t.integer :transaction_basket_id
      t.integer :property_id
      t.decimal :est_price, precision: 15, scale: 2
      t.decimal :est_cap_rate, precision: 15, scale: 2
    end
  end
end
