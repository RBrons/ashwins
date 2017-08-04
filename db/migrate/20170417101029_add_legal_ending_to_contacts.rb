class AddLegalEndingToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :legal_ending, :string
  end
end
