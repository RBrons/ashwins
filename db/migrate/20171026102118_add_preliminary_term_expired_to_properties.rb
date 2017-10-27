class AddPreliminaryTermExpiredToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :preliminary_term_expired, :boolean, default: false
  end
end
