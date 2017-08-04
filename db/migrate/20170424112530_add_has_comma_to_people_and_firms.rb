class AddHasCommaToPeopleAndFirms < ActiveRecord::Migration[5.0]
  def change
    add_column :people_and_firms, :has_comma, :boolean, :default => false
  end
end
