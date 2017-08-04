class AddIndexToGroupMembers < ActiveRecord::Migration[5.0]
  def change
    add_index :group_members , [:group_id , :gmember_id, :gmember_type] , :unique => true
  end
end
