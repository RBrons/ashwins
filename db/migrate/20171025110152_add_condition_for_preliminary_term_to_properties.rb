class AddConditionForPreliminaryTermToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :condition_for_preliminary_term, :string
  end
end
