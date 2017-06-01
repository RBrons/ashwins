class PropertyCoverImage < CloudinaryImage
  default_scope{ where(class_name: "PropertyCoverImage") }

  belongs_to :property
end