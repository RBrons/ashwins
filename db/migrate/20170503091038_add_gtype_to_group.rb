class AddGtypeToGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :gtype, :string, :null => false
  end
end
