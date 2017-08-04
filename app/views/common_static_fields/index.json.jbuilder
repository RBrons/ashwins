json.array!(@common_static_fields) do |common_static_field|
  json.extract! common_static_field, :id, :type_is, :title
  json.url common_static_field_url(common_static_field, format: :json)
end
