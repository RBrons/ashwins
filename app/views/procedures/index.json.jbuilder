json.array!(@procedures) do |procedure|
  json.extract! procedure, :id, :title, :property_id, :deleted, :key
  json.url procedure_url(procedure, format: :json)
end
