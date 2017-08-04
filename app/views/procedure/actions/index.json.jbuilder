json.array!(@procedure_actions) do |procedure_action|
  json.extract! procedure_action, :id, :title, :procedure_id, :deleted, :key
  json.url procedure_action_url(procedure_action, format: :json)
end
