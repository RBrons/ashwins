class RenameColumnsInProperties < ActiveRecord::Migration[5.0]
  def change
    rename_column :properties, :rent_commencement_depend_on_expiration, :has_date_certain_for_preliminary
  end
end
