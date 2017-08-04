class AddOfficeToPeopleAndFirms < ActiveRecord::Migration[5.0]
  def change
    add_column :people_and_firms, :office, :string
  end
end
