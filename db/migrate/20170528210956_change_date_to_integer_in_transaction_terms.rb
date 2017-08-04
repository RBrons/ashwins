class ChangeDateToIntegerInTransactionTerms < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_terms, :first_deposit_days_after_psa, :integer
    add_column :transaction_terms, :second_deposit_days_after_inspection_period, :integer
    add_column :transaction_terms, :closing_days_after_inspection_period, :integer
  end

  def down
    remove_column :transaction_terms, :first_deposit_days_after_psa, :integer
    remove_column :transaction_terms, :second_deposit_days_after_inspection_period, :integer
    remove_column :transaction_terms, :closing_days_after_inspection_period, :integer
  end
end
