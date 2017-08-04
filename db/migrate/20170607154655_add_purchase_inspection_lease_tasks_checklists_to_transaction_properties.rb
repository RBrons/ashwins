class AddPurchaseInspectionLeaseTasksChecklistsToTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_properties, :purchase_inspection_lease_tasks_abstract, :boolean, default: false
    add_column :transaction_properties, :purchase_inspection_lease_tasks_conference_with_clients, :boolean, default: false
  end
end
