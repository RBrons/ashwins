class AddModeToDefaultValues < ActiveRecord::Migration[5.0]
  def change
    add_column :default_values, :mode, :string
  end
end
