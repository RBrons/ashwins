class AddStartingDateOfLeaseAmendmentToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :starting_date_of_lease_amendment, :datetime
  end
end
