class AddUserIdToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :user_id, :integer, :default => 1
  end
end
