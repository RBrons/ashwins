class AddPreliminaryTermExpirationDateToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :preliminary_term_expiration_date, :date
  end
end
