class AddClassNameToCloudinaryImages < ActiveRecord::Migration[5.0]
  def change
    add_column :cloudinary_images, :class_name, :string
  end
end
