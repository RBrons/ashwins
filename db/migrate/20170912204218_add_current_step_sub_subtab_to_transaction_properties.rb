class AddCurrentStepSubSubtabToTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_properties, :current_step_sub_subtab, :string
  end
end
