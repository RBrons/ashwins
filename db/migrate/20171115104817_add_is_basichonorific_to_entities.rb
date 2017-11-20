class AddIsBasichonorificToEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :entities, :is_basichonorific, :boolean
  end
end
