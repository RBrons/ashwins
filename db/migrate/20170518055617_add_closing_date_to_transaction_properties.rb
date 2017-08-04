class AddClosingDateToTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_properties, :closing_date, :datetime
    add_column :transaction_properties, :closing_proceeds, :decimal, precision: 15, scale: 2
  end
end
