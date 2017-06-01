class CreateCloudinaryImages < ActiveRecord::Migration[5.0]
  def change
    create_table :cloudinary_images do |t|
      t.integer :property_id
      t.string :cl_image_public_id
      t.integer :cl_image_width
      t.integer :cl_image_height
      t.string :cl_image_format
      t.string :cl_image_url
      t.string :cl_image_url_secure
      t.string :cl_image_original_filename

      t.timestamps
    end
  end
end
