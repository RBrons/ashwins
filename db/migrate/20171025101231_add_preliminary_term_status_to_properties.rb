class AddPreliminaryTermStatusToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :preliminary_term_status, :boolean, default: false
  end
end
