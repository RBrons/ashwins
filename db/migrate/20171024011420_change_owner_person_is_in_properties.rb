class ChangeOwnerPersonIsInProperties < ActiveRecord::Migration[5.0]
  def change
    change_column :properties, :owner_person_is, 'integer USING CAST(owner_person_is AS integer)'
  end
end
