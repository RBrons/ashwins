class PropertyImage < CloudinaryImage
  default_scope{ where(class_name: "PropertyImage") }

  belongs_to :property
end