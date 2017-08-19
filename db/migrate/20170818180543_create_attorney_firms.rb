class CreateAttorneyFirms < ActiveRecord::Migration[5.0]
  def change
    create_table :attorney_firms do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
    end
  end
end
