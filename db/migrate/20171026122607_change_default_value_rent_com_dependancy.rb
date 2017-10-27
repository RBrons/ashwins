class ChangeDefaultValueRentComDependancy < ActiveRecord::Migration[5.0]
  def up
  	change_column :properties, :rent_commencement_depend_on_expiration, :boolean, :default => true
  end
end
