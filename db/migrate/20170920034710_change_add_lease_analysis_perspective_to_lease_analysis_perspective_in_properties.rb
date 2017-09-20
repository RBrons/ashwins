class ChangeAddLeaseAnalysisPerspectiveToLeaseAnalysisPerspectiveInProperties < ActiveRecord::Migration[5.0]
  def change
    rename_column :properties, :add_lease_analysis_perspective, :lease_analysis_perspective
  end
end
