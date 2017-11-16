class RemoveWrongColumnsFromProperties < ActiveRecord::Migration[5.0]
  def change
    # remove_column :properties, :premises_waste_sectionpremises_initial_opening_section, :string
    remove_column :properties, :premises_waste_ratingpremises_initial_opening_rating, :string

    # add_column :properties, :premises_waste_section, :string
    # add_column :properties, :premises_initial_opening_section, :string
  end
end
