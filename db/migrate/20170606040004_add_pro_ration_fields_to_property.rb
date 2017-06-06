class AddProRationFieldsToProperty < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :pro_rated_month, :integer
    add_column :properties, :pro_rated_month_name, :string
    add_column :properties, :pro_rated_year, :integer
    add_column :properties, :pro_rated_day, :integer
    add_column :properties, :pro_rated_day_date, :date
    add_column :properties, :pro_rated_day_rent, :decimal, precision: 15, scale: 2
    add_column :properties, :pro_rated_month_rent, :decimal, precision: 15, scale: 2
  end
end
