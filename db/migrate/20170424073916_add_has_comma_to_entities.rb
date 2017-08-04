class AddHasCommaToEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :entities, :has_comma, :boolean, :default => false
  end
end
