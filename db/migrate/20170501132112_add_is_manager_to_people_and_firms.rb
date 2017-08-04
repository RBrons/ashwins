class AddIsManagerToPeopleAndFirms < ActiveRecord::Migration[5.0]
  def change
    add_column :people_and_firms, :is_manager, :boolean, :default => false
  end
end
