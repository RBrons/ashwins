class CreateDefaultValues < ActiveRecord::Migration[5.0]
  def change
    create_table :default_values do |t|
      t.string :entity_name
      t.string :attribute_name
      t.string :value
      t.string :value_type

      t.timestamps
    end
  end
end
