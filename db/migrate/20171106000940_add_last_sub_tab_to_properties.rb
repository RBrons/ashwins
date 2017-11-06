class AddLastSubTabToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :last_sub_tab, :string
  end
end
