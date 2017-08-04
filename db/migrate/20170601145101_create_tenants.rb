class CreateTenants < ActiveRecord::Migration[5.0]
  def change
    create_table :tenants do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end

    User.all.each do |user|
      user.create_default_tenants
    end
  end
end
