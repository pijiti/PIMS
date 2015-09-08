json.array!(@pims_configs) do |pims_config|
  json.extract! pims_config, :id, :property_name, :property_value, :description
  json.url pims_config_url(pims_config, format: :json)
end
