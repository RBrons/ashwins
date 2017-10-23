json.array!(@dynamic_fields) do |dynamic_field|
  json.extract! dynamic_field, :id, :klass, :fields, :validation, :default_value
  json.url dynamic_field_url(dynamic_field, format: :json)
end
