class CreateRentTables < ActiveRecord::Migration[5.0]
  def change
    create_table :rent_tables do |t|
      t.decimal :rent, precision: 15, scale: 2
      t.integer :start_year
      t.integer :end_year
      t.references :property, foreign_key: true

      t.timestamps
    end
  end
end
