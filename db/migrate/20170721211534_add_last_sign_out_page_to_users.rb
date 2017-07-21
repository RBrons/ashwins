class AddLastSignOutPageToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_sign_out_page, :string
  end
end
