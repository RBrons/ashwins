class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :parent_id, :default => 0

      t.timestamps
    end
  end
end
