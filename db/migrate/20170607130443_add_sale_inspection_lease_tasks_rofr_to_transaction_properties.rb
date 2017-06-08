class AddSaleInspectionLeaseTasksRofrToTransactionProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_properties, :sale_inspection_lease_tasks_rofr, :boolean, default: false
  end
end
