class AddSkippedUserSetupToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :skipped_user_setup, :boolean, :default => false
  end
end
