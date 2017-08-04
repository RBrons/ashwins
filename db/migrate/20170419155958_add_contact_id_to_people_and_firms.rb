class AddContactIdToPeopleAndFirms < ActiveRecord::Migration[5.0]
  def change
    add_column :people_and_firms, :contact_id, :integer
  end
end
