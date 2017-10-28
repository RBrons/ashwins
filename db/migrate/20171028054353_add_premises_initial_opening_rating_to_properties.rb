class AddPremisesInitialOpeningRatingToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :premises_initial_opening_rating, :string
  end
end
