class AddCloudinaryFieldsToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :cl_image_public_id, :string
    add_column :properties, :cl_image_width, :integer
    add_column :properties, :cl_image_height, :integer
    add_column :properties, :cl_image_format, :string
    add_column :properties, :cl_image_url, :string
    add_column :properties, :cl_image_url_secure, :string
    add_column :properties, :cl_image_original_filename, :string
  end
end