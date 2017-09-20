class AddLeaseAnalysisPerspectiveToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :add_lease_analysis_perspective, :boolean, default: true
  end
end
