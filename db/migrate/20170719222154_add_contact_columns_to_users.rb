class AddContactColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :business_name, :string
    add_column :users, :business_contact_first_name, :string
    add_column :users, :business_contact_last_name, :string
  end
end
