class RenamePurchaseInspectionLeaseTasksChecklistsColumnsInTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    rename_column :transaction_properties, :purchase_inspection_lease_tasks_abstract, :purchase_inspection_lease_tasks_estoppel
    rename_column :transaction_properties, :purchase_inspection_lease_tasks_conference_with_clients, :purchase_inspection_lease_tasks_rofr
  end
end
