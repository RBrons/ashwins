class AddDeadlinesToTransactionMain < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_mains, :identification_deadline, :datetime
    add_column :transaction_mains, :transaction_deadline, :datetime
  end
end
