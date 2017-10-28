class AddAttributeRatingToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :premises_waste_rating, :string
  end
end
