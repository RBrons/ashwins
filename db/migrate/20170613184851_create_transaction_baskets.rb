class CreateTransactionBaskets < ActiveRecord::Migration[5.0]
  def change
    create_table :transaction_baskets do |t|
      t.string :basket_name
      t.integer :transaction_id
      t.string :identification_rule
      t.boolean :is_identified_to_qi
    end
  end
end