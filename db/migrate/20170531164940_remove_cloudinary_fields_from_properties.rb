class RemoveCloudinaryFieldsFromProperties < ActiveRecord::Migration[5.0]
  def change
    remove_column :properties, :cl_image_public_id, :string
    remove_column :properties, :cl_image_width, :integer
    remove_column :properties, :cl_image_height, :integer
    remove_column :properties, :cl_image_format, :string
    remove_column :properties, :cl_image_url, :string
    remove_column :properties, :cl_image_url_secure, :string
    remove_column :properties, :cl_image_original_filename, :string
  end
end
