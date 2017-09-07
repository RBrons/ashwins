class AddPersonnelCategoryToTransactionPersonnels < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_personnels, :personnel_category, :string
  end
end
