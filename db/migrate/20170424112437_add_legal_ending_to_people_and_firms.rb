class AddLegalEndingToPeopleAndFirms < ActiveRecord::Migration[5.0]
  def change
    add_column :people_and_firms, :legal_ending, :string
  end
end
