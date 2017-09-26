class CreatePropertyComments < ActiveRecord::Migration[5.0]
  def change
    create_table :property_comments do |t|
      t.integer :property_id
      t.integer :user_id
      t.string :comments
      t.string :type
    end
  end
end
