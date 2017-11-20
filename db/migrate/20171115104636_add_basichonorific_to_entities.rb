class AddBasichonorificToEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :entities, :basichonorific, :string
  end
end
