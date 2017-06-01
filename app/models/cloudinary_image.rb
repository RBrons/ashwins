class CloudinaryImage < ApplicationRecord

  def upload_image img
      # return json from cloudinary
      cl_hash = {}

      # upload to cloudinary
      cl_hash = Cloudinary::Uploader.upload(img)

      # process returned json result
      self.cl_image_public_id = cl_hash["public_id"] if cl_hash.key?("public_id")
      self.cl_image_width = cl_hash["width"] if cl_hash.key?("width")
      self.cl_image_height = cl_hash["height"] if cl_hash.key?("height")
      self.cl_image_format = cl_hash["format"] if cl_hash.key?("format")
      self.cl_image_url = cl_hash["url"] if cl_hash.key?("url")
      self.cl_image_url_secure = cl_hash["secure_url"] if cl_hash.key?("secure_url")
      self.cl_image_original_filename = cl_hash["original_filename"] if cl_hash.key?("original_filename")

      self.save
  end

end
