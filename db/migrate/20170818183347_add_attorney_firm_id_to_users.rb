class AddAttorneyFirmIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :attorney_firm_id, :integer
  end
end
