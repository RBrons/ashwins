class AddShareRelatedColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :entities, :shares_decimal_count, :integer
    add_column :people_and_firms, :my_percentage_stockholder, :decimal

    StockHolder.all.each do |s|
      s.my_percentage_stockholder = s.my_percentage
      s.save
    end
  end
end
