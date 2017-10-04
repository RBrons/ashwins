class AddUserRoleAtLawFirmToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_role_at_law_firm, :string
  end
end
