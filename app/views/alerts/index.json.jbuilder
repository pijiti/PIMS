json.array!(@alerts) do |alert|
  json.extract! alert, :id, :message, :store_id, :status, :user_id
  json.url alert_url(alert, format: :json)
end
